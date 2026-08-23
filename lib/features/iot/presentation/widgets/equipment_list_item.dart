import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class EquipmentListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String consumptionDetail;
  final VoidCallback onDelete;

  const EquipmentListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.consumptionDetail,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: AppTheme.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.11,
            color: Colors.black.withValues(alpha: 0.08),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: ShapeDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryOrange,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textColorDark,
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
                Text(
                  consumptionDetail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 28,
              height: 28,
              decoration: ShapeDecoration(
                color: const Color(0xFFFEF2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppTheme.errorColor,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
