import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

import 'package:go_router/go_router.dart';

import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';
import 'package:gezi/core/shared_widgets/buttons/primary_button.dart';

import '../widgets/meter_balance_card.dart';
import '../widgets/meter_stats_row.dart';
import '../widgets/meter_consumption_chart.dart';
import '../widgets/meter_recent_transactions.dart';

class MeterDetailPage extends StatelessWidget {
  final Meter meter;
  final List<Recharge> recentRecharges;

  const MeterDetailPage({
    super.key,
    required this.meter,
    required this.recentRecharges,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    
    // Filter for successful recharges only
    final successfulRecharges = recentRecharges
        .where((r) => r.status == RechargeStatus.success)
        .toList();

    final thisMonthRecharges = successfulRecharges
        .where((r) => r.rechargedAt.isAfter(monthStart))
        .toList();
    final double monthlyKwh = thisMonthRecharges.fold(
      0.0,
      (acc, r) => acc + r.kwhAmount,
    );

    // Estimate daily average and autonomy based on recharge intervals
    double dailyAvgKwh = 2.1;
    int daysBetweenRecharges = 15;
    if (successfulRecharges.length >= 2) {
      final sorted = List<Recharge>.from(successfulRecharges)
        ..sort((a, b) => a.rechargedAt.compareTo(b.rechargedAt));
      final totalIntervalDays =
          sorted.last.rechargedAt.difference(sorted.first.rechargedAt).inDays;
      if (totalIntervalDays > 0) {
        final totalKwh = sorted.fold(0.0, (acc, r) => acc + r.kwhAmount);
        dailyAvgKwh = double.parse(
          (totalKwh / totalIntervalDays).toStringAsFixed(1),
        ).clamp(0.5, 50.0);
        daysBetweenRecharges =
            (totalIntervalDays / (sorted.length - 1)).round().clamp(1, 90);
      }
    } else if (successfulRecharges.length == 1) {
      dailyAvgKwh = (successfulRecharges.first.kwhAmount / 15).clamp(1.0, 10.0);
    }
    final int estimatedDaysRemaining =
        (dailyAvgKwh > 0) ? (meter.kwhBalance / dailyAvgKwh).round() : 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMeterHeader(context),
              MeterBalanceCard(meter: meter),
              MeterStatsRow(
                monthlyKwh: monthlyKwh > 0 ? monthlyKwh : 64.7,
                dailyAvgKwh: dailyAvgKwh,
                rechargeCount: successfulRecharges.length,
              ),
              _buildEstimationCard(
                context,
                dailyAvgKwh,
                daysBetweenRecharges,
                estimatedDaysRemaining,
              ),
              const MeterConsumptionChart(),
              MeterRecentTransactions(recharges: recentRecharges),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 12),
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
  }

  Widget _buildEstimationCard(
    BuildContext context,
    double dailyAvgKwh,
    int daysBetweenRecharges,
    int estimatedDaysRemaining,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
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
              'Com base na frequência das recargas (média a cada $daysBetweenRecharges dias), o seu consumo estimado é de ${dailyAvgKwh.toStringAsFixed(1)} kWh/dia.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildMeterHeader(BuildContext context) {
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
            child: const Icon(Icons.flash_on_rounded, color: AppTheme.primaryOrange),
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: meter.isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(37282700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: meter.isOnline ? const Color(0xFF00C950) : const Color(0xFF9CA3AF),
                    borderRadius: BorderRadius.circular(37282700),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  meter.isOnline ? 'Online' : 'Offline',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: meter.isOnline ? const Color(0xFF008236) : const Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
