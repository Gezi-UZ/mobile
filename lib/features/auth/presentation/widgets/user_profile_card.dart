import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class UserProfileCard extends StatelessWidget {
  final String userName;
  final String phoneNumber;

  const UserProfileCard({
    super.key,
    this.userName = 'Ana Machava',
    this.phoneNumber = '+258 84 123 4567',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightOrangeBackground,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1.11,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person,
              color: AppTheme.primaryOrange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.textColorDark,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                phoneNumber,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textColorSecondary,
                      fontSize: 12,
                      height: 1.33,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
