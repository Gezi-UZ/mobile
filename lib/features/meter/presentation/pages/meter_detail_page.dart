import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';
import 'package:gezi/features/home/presentation/bloc/home_bloc.dart';
import 'package:gezi/features/home/presentation/bloc/home_event.dart';
import 'package:gezi/features/home/presentation/bloc/home_state.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_bloc.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_event.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_state.dart';
import 'package:gezi/core/shared_widgets/buttons/primary_button.dart';
import 'package:gezi/injection_container.dart';

import '../widgets/meter_balance_card.dart';
import '../widgets/meter_stats_row.dart';
import '../widgets/meter_consumption_chart.dart';
import '../widgets/meter_recent_transactions.dart';
import '../widgets/chart_data_point.dart';

/// MeterDetailPage observa o [HomeBloc] e o [MeterBloc] em tempo real.
/// Quando uma nova recarga é concluída e o HomeBloc refresca os dados,
/// esta página reconstrói automaticamente com os valores actualizados.
class MeterDetailPage extends StatefulWidget {
  final Meter meter;

  /// Recargas iniciais passadas via router (snapshot). A página ignora-as
  /// assim que o HomeBloc emitir [HomeLoaded] com dados frescos.
  final List<Recharge> initialRecharges;

  const MeterDetailPage({
    super.key,
    required this.meter,
    this.initialRecharges = const [],
  });

  @override
  State<MeterDetailPage> createState() => _MeterDetailPageState();
}

class _MeterDetailPageState extends State<MeterDetailPage> {
  @override
  void initState() {
    super.initState();
    // Forçar refresh dos dados ao entrar na página.
    sl<HomeBloc>().add(const HomeDashboardLoadRequested(isRefresh: true));
    sl<MeterBloc>().add(const MeterListRequested());
  }

  /// Calcula as métricas a partir das recargas disponíveis.
  _MeterMetrics _computeMetrics(List<Recharge> recentRecharges, Meter meter) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    // Filtrar apenas recargas bem-sucedidas do contador atual
    final successfulRecharges = recentRecharges
        .where((r) => r.status == RechargeStatus.success && r.meterSerialNumber == meter.serialNumber)
        .toList();

    final thisMonthRecharges = successfulRecharges
        .where((r) => r.rechargedAt.isAfter(monthStart))
        .toList();

    final double monthlyKwh = thisMonthRecharges.fold(
      0.0,
      (acc, r) => acc + r.kwhAmount,
    );

    double dailyAvgKwh = 0.0;
    int daysBetweenRecharges = 0;

    if (successfulRecharges.length >= 2) {
      final sorted = List<Recharge>.from(successfulRecharges)
        ..sort((a, b) => a.rechargedAt.compareTo(b.rechargedAt));
      final totalIntervalDays =
          sorted.last.rechargedAt.difference(sorted.first.rechargedAt).inDays;
      if (totalIntervalDays > 0) {
        final totalKwh = sorted.fold(0.0, (acc, r) => acc + r.kwhAmount);
        dailyAvgKwh =
            (totalKwh / totalIntervalDays).clamp(0.5, 50.0);
        daysBetweenRecharges =
            (totalIntervalDays / (sorted.length - 1)).round().clamp(1, 90);
      }
    } else if (successfulRecharges.length == 1) {
      dailyAvgKwh =
          (successfulRecharges.first.kwhAmount / 15).clamp(1.0, 10.0);
      daysBetweenRecharges = 15;
    }

    final int estimatedDaysRemaining =
        (dailyAvgKwh > 0) ? (meter.kwhBalance / dailyAvgKwh).round() : 0;

    final hasData = successfulRecharges.isNotEmpty;
    
    // 1. Dados da semana (últimos 7 dias)
    final List<ChartDataPoint> weeklyData = [];
    if (hasData) {
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final label = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
        final dailyKwh = successfulRecharges
            .where((r) => r.rechargedAt.year == date.year && r.rechargedAt.month == date.month && r.rechargedAt.day == date.day)
            .fold(0.0, (sum, r) => sum + r.kwhAmount);
        weeklyData.add(ChartDataPoint(label: label, value: dailyKwh));
      }
    }

    // 2. Dados do mês (últimas 4 semanas)
    final List<ChartDataPoint> monthlyData = [];
    if (hasData) {
      for (int i = 3; i >= 0; i--) {
        final endDate = now.subtract(Duration(days: i * 7));
        final startDate = endDate.subtract(const Duration(days: 6));
        final label = 'Sem ${4 - i}';
        final weeklyKwh = successfulRecharges
            .where((r) => 
                r.rechargedAt.isAfter(startDate.subtract(const Duration(milliseconds: 1))) && 
                r.rechargedAt.isBefore(endDate.add(const Duration(days: 1))))
            .fold(0.0, (sum, r) => sum + r.kwhAmount);
        monthlyData.add(ChartDataPoint(label: label, value: weeklyKwh));
      }
    }

    return _MeterMetrics(
      monthlyKwh: monthlyKwh,
      dailyAvgKwh: dailyAvgKwh,
      rechargeCount: successfulRecharges.length,
      daysBetweenRecharges: daysBetweenRecharges,
      estimatedDaysRemaining: estimatedDaysRemaining,
      allRecharges: recentRecharges.where((r) => r.meterSerialNumber == meter.serialNumber).toList(),
      weeklyChartData: weeklyData,
      monthlyChartData: monthlyData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<HomeBloc>()),
        BlocProvider.value(value: sl<MeterBloc>()),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, homeState) {
          // Usar recargas do HomeBloc quando disponíveis; caso contrário usar o snapshot inicial.
          final List<Recharge> recentRecharges = homeState is HomeLoaded
              ? homeState.recentRecharges
              : widget.initialRecharges;

          // Usar o meter actualizado do MeterBloc (tem o saldo mais recente).
          final Meter activeMeter = () {
            final meterState = context.read<MeterBloc>().state;
            if (meterState is MeterLoaded && meterState.meters.isNotEmpty) {
              return meterState.meters.cast<Meter>().firstWhere(
                (m) => m.id == widget.meter.id,
                orElse: () => widget.meter,
              );
            }
            return widget.meter;
          }();

          final metrics = _computeMetrics(recentRecharges, activeMeter);

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              iconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.onSurface),
              actions: [
                // Botão de refresh manual
                if (homeState is HomeLoading)
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () {
                      sl<HomeBloc>()
                          .add(const HomeDashboardLoadRequested(isRefresh: true));
                      sl<MeterBloc>().add(const MeterListRequested());
                    },
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMeterHeader(context, activeMeter),
                    MeterBalanceCard(meter: activeMeter),
                    MeterStatsRow(
                      monthlyKwh: metrics.monthlyKwh,
                      dailyAvgKwh: metrics.dailyAvgKwh,
                      rechargeCount: metrics.rechargeCount,
                    ),
                    _buildEstimationCard(
                      context,
                      metrics.dailyAvgKwh,
                      metrics.daysBetweenRecharges,
                      metrics.estimatedDaysRemaining,
                    ),
                    MeterConsumptionChart(
                      weeklyData: metrics.weeklyChartData,
                      monthlyData: metrics.monthlyChartData,
                    ),
                    MeterRecentTransactions(recharges: metrics.allRecharges),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20, top: 12),
                child: SizedBox(
                  child: PrimaryButton(
                    text: 'Recarregar este contador',
                    icon: Image.asset(
                      'assets/images/recharge_icon.png',
                      width: 24,
                      height: 24,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    onPressed: () {
                      context.push('/recharge');
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEstimationCard(
    BuildContext context,
    double dailyAvgKwh,
    int daysBetweenRecharges,
    int estimatedDaysRemaining,
  ) {
    // Se ainda não há dados suficientes, não mostrar o card
    if (dailyAvgKwh == 0.0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .extension<AppColorsExtension>()!
              .lightOrangeBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
            width: 1.11,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.insights_rounded,
                  color: AppTheme.darkerOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estimativa de Autonomia',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.darkerOrange,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Com base na frequência das recargas (média a cada $daysBetweenRecharges dias), '
              'o seu consumo estimado é de ${dailyAvgKwh.toStringAsFixed(2)} kWh/dia.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Autonomia prevista:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    '~$estimatedDaysRemaining dias restantes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: estimatedDaysRemaining <= 3
                              ? Colors.red
                              : AppTheme.darkerOrange,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeterHeader(BuildContext context, Meter meter) {
    final bool isOnline = () {
      if (meter.isOnline) return true;
      final sync = meter.lastSyncAt;
      if (sync == null) return false;
      return DateTime.now().difference(sync.toLocal()).inMinutes <= 5;
    }();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.flash_on_rounded,
                color: AppTheme.primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meter.alias,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  meter.serialNumber,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(37282700),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? const Color(0xFF00C950)
                            : const Color(0xFF9CA3AF),
                        borderRadius: BorderRadius.circular(37282700),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isOnline
                                ? const Color(0xFF008236)
                                : const Color(0xFF6B7280),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              if (meter.lastSyncAt != null)
                Text(
                  _formatLastSync(meter.lastSyncAt!),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastSync(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt.toLocal());
    if (diff.inMinutes < 1) return 'sync agora mesmo';
    if (diff.inMinutes < 60) return 'sync há ${diff.inMinutes} min';
    if (diff.inHours < 24) {
      final h = dt.toLocal().hour.toString().padLeft(2, '0');
      final m = dt.toLocal().minute.toString().padLeft(2, '0');
      return 'sync $h:$m';
    }
    final d = dt.toLocal().day.toString().padLeft(2, '0');
    final mo = dt.toLocal().month.toString().padLeft(2, '0');
    return 'sync $d/$mo';
  }
}

/// Dados calculados das métricas do contador.
class _MeterMetrics {
  final double monthlyKwh;
  final double dailyAvgKwh;
  final int rechargeCount;
  final int daysBetweenRecharges;
  final int estimatedDaysRemaining;
  final List<Recharge> allRecharges;
  final List<ChartDataPoint> weeklyChartData;
  final List<ChartDataPoint> monthlyChartData;

  const _MeterMetrics({
    required this.monthlyKwh,
    required this.dailyAvgKwh,
    required this.rechargeCount,
    required this.daysBetweenRecharges,
    required this.estimatedDaysRemaining,
    required this.allRecharges,
    required this.weeklyChartData,
    required this.monthlyChartData,
  });
}
