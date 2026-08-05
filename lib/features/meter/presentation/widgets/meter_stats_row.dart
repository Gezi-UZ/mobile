import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class MeterStatsRow extends StatelessWidget {
  const MeterStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard(context, 'Este mês', '64.7 kWh')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(context, 'Dia médio', '2.1 kWh')),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard(context, 'Recargas', '3')),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
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
              color: AppTheme.textColorSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.textColorDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
