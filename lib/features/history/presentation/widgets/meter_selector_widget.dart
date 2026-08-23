import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class MeterSelectorWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const MeterSelectorWidget({
    super.key,
    this.title = 'Todos os contadores',
    this.subtitle = '3 contadores registados',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.08),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppTheme.primaryOrange,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.textColorDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textColorSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textColorDark,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
