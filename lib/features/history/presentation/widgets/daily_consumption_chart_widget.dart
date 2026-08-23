import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class DailyConsumptionChartWidget extends StatelessWidget {
  const DailyConsumptionChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the chart
    final List<Map<String, dynamic>> chartData = [
      {'date': '13/06', 'value': 2.5},
      {'date': '14/06', 'value': 3.7},
      {'date': '15/06', 'value': 5.2},
      {'date': '16/06', 'value': 7.8},
      {'date': '17/06', 'value': 4.1},
      {'date': '18/06', 'value': 6.0},
      {'date': '19/06', 'value': 8.5},
    ];

    final double maxValue = 10.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
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
            'Consumo diário · kWh',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textColorSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((data) {
                final double percentage = data['value'] / maxValue;
                return _buildBar(context, data['date'], percentage);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, String date, double percentage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 24,
              height: 90 * percentage, // Max height for bar is roughly 90
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          date,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.textColorSecondary,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
