import 'package:flutter/material.dart';
import 'package:gezi/features/recharge/domain/entities/dashboard_stats.dart';
import 'package:gezi/core/theme/theme.dart';

class EnergySummaryCard extends StatelessWidget {
  final DashboardStats? stats;

  const EnergySummaryCard({
    super.key,
    this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final double energyReceived = stats?.totalKwhPurchased ?? 0.0;
    final String energyUnit = 'kWh';
    final String totalPaid = '${stats?.totalSpentMzn.toStringAsFixed(0) ?? 0} MZN';
    final int rechargesCount = stats?.rechargeCount ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Energia recebida esta semana',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$energyReceived ',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                      ),
                ),
                TextSpan(
                  text: energyUnit,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSubCard(
                  context,
                  title: 'Total pago',
                  value: totalPaid,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSubCard(
                  context,
                  title: 'Recargas',
                  value: rechargesCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubCard(BuildContext context, {required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColorsExtension>()!.inputBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
