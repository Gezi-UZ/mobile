import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class RechargeActionsWidget extends StatelessWidget {
  final VoidCallback? onRecharge;
  final VoidCallback? onHistory;

  const RechargeActionsWidget({super.key, this.onRecharge, this.onHistory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, right: 26, bottom: 16),
      child: Column(
        spacing: 12,
        children: [
          // Botão primário
          SizedBox(
            width: double.infinity,
            height: 60,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                gradient: AppTheme.primaryGradient,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: TextButton.icon(
                onPressed: onRecharge,
                icon: Image.asset(
                  'assets/images/recharge_icon.png',
                  height: 20,
                  width: 20,
                ),
                label: Text(
                  'Recarregar agora',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
          // Botão secundário
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: onHistory,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppTheme.primaryOrange,
                  width: 1.11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(
                Icons.share_outlined,
                color: AppTheme.primaryOrange,
              ),
              label: Text(
                'Recarregar para alguém',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppTheme.primaryOrange),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
