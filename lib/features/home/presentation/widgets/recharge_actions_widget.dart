import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/core/shared_widgets/buttons/primary_button.dart';
import 'package:gezi/core/shared_widgets/buttons/secondary_button.dart';

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
          PrimaryButton(
            text: 'Recarregar agora',
            onPressed: onRecharge,
            icon: Image.asset(
              'assets/images/recharge_icon.png',
              height: 20,
              width: 20,
              color: AppTheme.white,
            ),
          ),
          // Botão secundário
          SecondaryButton(
            text: 'Recarregar para alguém',
            onPressed: onHistory,
            icon: const Icon(
              Icons.share_outlined,
              color: AppTheme.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}
