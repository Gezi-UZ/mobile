import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class MeterConsumptionChart extends StatelessWidget {
  const MeterConsumptionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange,
                  borderRadius: BorderRadius.circular(37282700),
                ),
                child: Text(
                  'Semana',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(37282700),
                ),
                child: Text(
                  'Mês',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1.11,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consumo (kWh)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Placeholder for chart
                Container(
                  width: double.infinity,
                  height: 110,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartBar(context, '13/06', 40),
                      _buildChartBar(context, '14/06', 60),
                      _buildChartBar(context, '15/06', 30),
                      _buildChartBar(context, '16/06', 80),
                      _buildChartBar(context, '17/06', 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, String label, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textColorSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
