import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class RechargeTileWidget extends StatelessWidget {
  final String dateHeader;
  final String energyAmount;
  final String timeAndMethod;
  final String cost;
  final String status;
  final Color statusColor;

  const RechargeTileWidget({
    super.key,
    this.dateHeader = '18 JUN 2026',
    this.energyAmount = '18.5 kWh',
    this.timeAndMethod = '14:32 · M-Pesa · CR...92',
    this.cost = '500 MZN',
    this.status = 'Concluída',
    this.statusColor = const Color(0xFF2E7D32), // Default to success green
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              dateHeader,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.55,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
              right: 16,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: AppTheme.white,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 4,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline, // Can be dynamic based on status
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        energyAmount,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.textColorDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeAndMethod,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textColorSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cost,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.textColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
