import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

/// Abre o bottom sheet de acções rápidas via FAB do BottomNavBar.
/// Uso: showModalBottomSheet(context: context, builder: (_) => const QuickActionsBottomSheet());
class QuickActionsBottomSheet extends StatelessWidget {
  const QuickActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      decoration: const ShapeDecoration(
        color: AppTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        shadows: [
          BoxShadow(
            color: AppTheme.textColorDark,
            blurRadius: 50,
            offset: Offset(0, 25),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: ShapeDecoration(
                color: Colors.black.withValues(alpha: 0.08),
                shape: const StadiumBorder(),
              ),
            ),
          ),

          // Título
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 4),
            child: Text(
              'O QUE QUER FAZER?',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.textColorSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.30,
              ),
            ),
          ),

          // Acções
          _QuickActionItem(
            icon: Icons.electric_meter_outlined,
            title: 'Adicionar contador',
            subtitle: 'Associar um novo contador à minha conta',
            onTap: () {
              Navigator.pop(context);
              // TODO: context.push(AppRoutes.addMeter)
            },
          ),
          _QuickActionItem(
            icon: Icons.qr_code_scanner_outlined,
            title: 'Inserir código de recarga',
            subtitle: 'Tenho um código de 20 dígitos para aplicar',
            onTap: () {
              Navigator.pop(context);
              context.push('/recharge/code');
            },
          ),
          _QuickActionItem(
            icon: Icons.person_outline_rounded,
            title: 'Recarregar energia para alguém',
            subtitle: 'Recarregar o contador de outra pessoa directamente',
            onTap: () {
              Navigator.pop(context);
              context.push('/recharge?someone=true');
            },
          ),
        ],
      ),
    );
  }
}

/// Item individual da lista de acções — widget privado deste ficheiro.
class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          spacing: 16,
          children: [
            // Ícone
            Container(
              width: 44,
              height: 44,
              decoration: ShapeDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
            ),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.textColorDark,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textColorSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
