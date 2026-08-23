import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileLogoutButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.11,
              color: AppTheme.errorColor,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: AppTheme.errorColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Terminar sessão',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.errorColor,
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
