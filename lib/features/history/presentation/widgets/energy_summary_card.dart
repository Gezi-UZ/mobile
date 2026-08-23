import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class EnergySummaryCard extends StatelessWidget {
  final double energyReceived;
  final String energyUnit;
  final String totalPaid;
  final int rechargesCount;

  const EnergySummaryCard({
    super.key,
    this.energyReceived = 64.7,
    this.energyUnit = 'kWh',
    this.totalPaid = '1750 MZN',
    this.rechargesCount = 3,
  });

  @override
  Widget build(BuildContext context) {
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
            'Energia recebida esta semana',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColorSecondary,
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
                        color: AppTheme.textColorDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                      ),
                ),
                TextSpan(
                  text: energyUnit,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColorSecondary,
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
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColorSecondary,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textColorDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
