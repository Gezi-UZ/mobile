import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class UserProfileCard extends StatelessWidget {
  final String userName;
  final String phoneNumber;

  const UserProfileCard({
    super.key,
    this.userName = 'Dai Wen Xuan',
    this.phoneNumber = '+258 83 361 7829',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppTheme.lightOrangeBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: ShapeDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person,
              color: AppTheme.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textColorDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.50,
                  ),
                ),
                Opacity(
                  opacity: 0.61,
                  child: Text(
                    phoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textColorSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
