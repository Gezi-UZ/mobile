import 'package:flutter/material.dart';

class MeterStatsRow extends StatelessWidget {
  final double monthlyKwh;
  final double dailyAvgKwh;
  final int rechargeCount;

  const MeterStatsRow({
    super.key,
    this.monthlyKwh = 0.0,
    this.dailyAvgKwh = 0.0,
    this.rechargeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              'Este mês',
              monthlyKwh > 0
                  ? '${monthlyKwh.toStringAsFixed(2)} kWh'
                  : '— kWh',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'Dia médio',
              dailyAvgKwh > 0
                  ? '${dailyAvgKwh.toStringAsFixed(2)} kWh'
                  : '— kWh',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'Recargas',
              '$rechargeCount',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1.11,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
