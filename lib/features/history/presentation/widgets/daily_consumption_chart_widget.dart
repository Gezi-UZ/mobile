import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/recharge/domain/entities/recharge.dart';
import 'package:intl/intl.dart';

class DailyConsumptionChartWidget extends StatelessWidget {
  final List<Recharge> recharges;

  const DailyConsumptionChartWidget({
    super.key,
    required this.recharges,
  });

  @override
  Widget build(BuildContext context) {
    // Generate the last 7 days (including today)
    final now = DateTime.now();
    final List<Map<String, dynamic>> chartData = [];
    double maxValue = 0.0;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateString = DateFormat('dd/MM').format(date);
      
      // Calculate total kwh for this day
      double dailyTotal = 0;
      for (final recharge in recharges) {
        if (recharge.createdAt.year == date.year &&
            recharge.createdAt.month == date.month &&
            recharge.createdAt.day == date.day) {
          dailyTotal += recharge.creditKwh;
        }
      }

      if (dailyTotal > maxValue) {
        maxValue = dailyTotal;
      }

      chartData.add({
        'date': dateString,
        'value': dailyTotal,
      });
    }

    // Ensure we don't divide by zero
    if (maxValue == 0) {
      maxValue = 10.0; // Default max to avoid division by zero
    } else {
      // Add a little padding to the max value for better visual
      maxValue = maxValue * 1.2;
    }

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
            'Consumo diário · kWh',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                final double percentage = (data['value'] as double) / maxValue;
                return _buildBar(context, data['date'] as String, percentage);
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}
