

import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class LowBalanceAlertWidget extends StatelessWidget {
  const LowBalanceAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: AppTheme.lightOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          spacing: 12,
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.textColorDark),
            Expanded(
              child: Text(
                'Saldo baixo — recarregue para evitar interrupção.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textColorDark,
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
