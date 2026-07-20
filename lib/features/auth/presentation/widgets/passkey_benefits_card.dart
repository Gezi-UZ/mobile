import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PasskeyBenefitsCard extends StatelessWidget {
  const PasskeyBenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBenefitItem(
          context,
          icon: Icons.security_rounded,
          title: 'Mais seguro que uma password',
          subtitle:
              'Ligada ao seu dispositivo, não pode ser roubada em data breaches.',
        ),
        const SizedBox(height: 12),
        _buildBenefitItem(
          context,
          icon: Icons.touch_app_rounded,
          title: 'Entrada em 1 toque',
          subtitle: 'Sem precisar de lembrar passwords ou esperar por SMS.',
        ),
        const SizedBox(height: 12),
        _buildBenefitItem(
          context,
          icon: Icons.fingerprint_rounded,
          title: 'Impressão digital ou PIN',
          subtitle:
              'Escolha o método que preferir, ambos são igualmente seguros.',
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightOrangeBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textColorDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                    fontSize: 12,
                    height: 1.33,
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
