import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/history/presentation/bloc/history_cubit.dart';
import 'package:gezi/features/history/presentation/widgets/daily_consumption_chart_widget.dart';
import 'package:gezi/features/history/presentation/widgets/energy_summary_card.dart';
import 'package:gezi/features/history/presentation/widgets/history_header_widget.dart';
import 'package:gezi/features/history/presentation/widgets/meter_selector_widget.dart';
import 'package:gezi/features/history/presentation/widgets/time_filter_toggle_widget.dart';
import 'package:gezi/features/history/presentation/widgets/recharge_tile_widget.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_bloc.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_state.dart';
import 'package:gezi/injection_container.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HistoryCubit>()),
        BlocProvider.value(value: sl<MeterBloc>()),
      ],
      child: const HistoryPageView(),
    );
  }
}

class HistoryPageView extends StatefulWidget {
  const HistoryPageView({super.key});

  @override
  State<HistoryPageView> createState() => _HistoryPageViewState();
}

class _HistoryPageViewState extends State<HistoryPageView> {
  Meter? _selectedMeter;
  String _currentPeriod = 'week'; // week, month, year

  @override
  void initState() {
    super.initState();
    final meterState = context.read<MeterBloc>().state;
    if (meterState is MeterLoaded && meterState.meters.isNotEmpty) {
      _selectedMeter = meterState.primaryMeter ?? meterState.meters.first;
      _fetchHistory();
    }
  }

  void _fetchHistory() {
    if (_selectedMeter != null) {
      context.read<HistoryCubit>().fetchHistoryData(_selectedMeter!.id, _currentPeriod);
    }
  }

  void _showMeterSelectionBottomSheet(List<Meter> meters) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecione um contador',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16),
                ...meters.map((meter) {
                  final isSelected = _selectedMeter?.id == meter.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                            : Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.bolt_rounded,
                        color: isSelected ? AppTheme.primaryOrange : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    title: Text(
                      meter.alias,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                    ),
                    subtitle: Text(
                      meter.serialNumber,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedMeter = meter;
                      });
                      _fetchHistory();
                      Navigator.pop(bottomSheetContext);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocConsumer<MeterBloc, MeterState>(
          listener: (context, meterState) {
            if (meterState is MeterLoaded && meterState.meters.isNotEmpty && _selectedMeter == null) {
              setState(() {
                _selectedMeter = meterState.primaryMeter ?? meterState.meters.first;
              });
              _fetchHistory();
            }
          },
          builder: (context, meterState) {
            final meters = meterState is MeterLoaded ? meterState.meters : <Meter>[];
            final meterName = _selectedMeter?.alias ?? 'Nenhum contador';
            final meterSubtitle = _selectedMeter != null 
                ? 'Contador: ${_selectedMeter!.serialNumber}' 
                : 'Sem contadores registados';

            return RefreshIndicator(
              onRefresh: () async {
                _fetchHistory();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HistoryHeaderWidget(
                        onFilterTap: () {},
                      ),
                      const SizedBox(height: 20),
                      MeterSelectorWidget(
                        title: meterName,
                        subtitle: meterSubtitle,
                        onTap: () {
                          if (meters.isNotEmpty) {
                            _showMeterSelectionBottomSheet(meters);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TimeFilterToggleWidget(
                        onFilterChanged: (filter) {
                          setState(() {
                            if (filter == TimeFilter.semana) {
                              _currentPeriod = 'week';
                            } else if (filter == TimeFilter.mes) {
                              _currentPeriod = 'month';
                            } else if (filter == TimeFilter.anual) {
                              _currentPeriod = 'year';
                            } else {
                              _currentPeriod = 'week';
                            }
                          });
                          _fetchHistory();
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<HistoryCubit, HistoryState>(
                        builder: (context, historyState) {
                          if (historyState is HistoryLoading) {
                            return const Center(child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (historyState is HistoryError) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text('Erro: ${historyState.message}'),
                            ));
                          } else if (historyState is HistoryLoaded) {
                            final stats = historyState.stats;
                            final recharges = historyState.recharges;
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                EnergySummaryCard(
                                  stats: stats,
                                ),
                                const SizedBox(height: 16),
                                DailyConsumptionChartWidget(
                                  recharges: recharges,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Recargas efectuadas',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                if (recharges.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    child: Center(child: Text('Nenhuma recarga efectuada.')),
                                  )
                                else
                                  ...recharges.map((recharge) {
                                    final isSuccess = recharge.status.toLowerCase() == 'success' || recharge.status.toLowerCase() == 'concluída';
                                    final isPending = recharge.status.toLowerCase() == 'pending' || recharge.status.toLowerCase() == 'pendente';
                                    final statusText = isSuccess ? 'Concluída' : (isPending ? 'Pendente' : 'Falhou');
                                    final statusColor = isSuccess ? const Color(0xFF2E7D32) : (isPending ? const Color(0xFFFFB300) : const Color(0xFFFF3B30));
                                    final creditKwhStr = isSuccess ? '${recharge.creditKwh.toStringAsFixed(1)} kWh' : '-';

                                    return RechargeTileWidget(
                                      dateHeader: DateFormat('dd MMM yyyy').format(recharge.createdAt).toUpperCase(),
                                      energyAmount: creditKwhStr,
                                      timeAndMethod: '${DateFormat('HH:mm').format(recharge.createdAt)} · M-Pesa',
                                      cost: '${recharge.amountMzn.toStringAsFixed(0)} MZN',
                                      status: statusText,
                                      statusColor: statusColor,
                                      rechargeType: recharge.rechargeType,
                                      otherPartyName: recharge.otherPartyName,
                                    );
                                  }),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
