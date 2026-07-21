import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PasskeyMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const PasskeyMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MÉTODO DA PASSKEY',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textColorSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMethodCard(
                context,
                id: 'fingerprint',
                label: 'Impressão digital',
                icon: Icons.fingerprint_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMethodCard(
                context,
                id: 'pin',
                label: 'PIN',
                icon: Icons.lock_outline_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodCard(
    BuildContext context, {
    required String id,
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedMethod == id;

    return GestureDetector(
      onTap: () => onMethodSelected(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lightOrangeBackground : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryOrange
                : Colors.black.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? AppTheme.primaryOrange
                  : AppTheme.textColorSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.textColorDark,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
