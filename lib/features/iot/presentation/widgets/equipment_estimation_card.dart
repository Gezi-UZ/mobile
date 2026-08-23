import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class EquipmentEstimationCard extends StatelessWidget {
  final double estimateValue;

  const EquipmentEstimationCard({
    super.key,
    required this.estimateValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        gradient: AppTheme.primaryGradient,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Estimativa de consumo diário',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.white.withValues(alpha: 0.70),
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            estimateValue.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w700,
              fontSize: 36,
              height: 1.11,
            ),
          ),
          Text(
            'kWh / dia',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.white.withValues(alpha: 0.80),
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}
