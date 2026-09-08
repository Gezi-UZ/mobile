import 'package:flutter/material.dart';

class LowBalanceAlertWidget extends StatelessWidget {
  final double balance;

  const LowBalanceAlertWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF3D2600) : const Color(0xFFFFF3DC);
    final contentColor = isDark ? const Color(0xFFFFC107) : const Color(0xFFB45309);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          spacing: 12,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: contentColor,
            ),
            Expanded(
              child: Text(
                balance <= 0
                    ? 'Saldo zero — recarregue.'
                    : 'Saldo baixo — recarregue para evitar interrupção.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: contentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
