import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class TransactionListItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isCredit;
  final IconData icon;

  const TransactionListItem({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    this.isCredit = false,
    this.icon = Icons.receipt_long,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppTheme.lightOrangeBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textColorDark,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textColorSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${isCredit ? '+' : '-'} $amount',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isCredit ? AppTheme.successColor : AppTheme.textColorDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
