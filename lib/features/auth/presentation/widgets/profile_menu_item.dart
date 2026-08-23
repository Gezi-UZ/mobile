import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              width: 32,
              height: 32,
              decoration: ShapeDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                shape: const CircleBorder(),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryOrange,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textColorDark,
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textColorSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
