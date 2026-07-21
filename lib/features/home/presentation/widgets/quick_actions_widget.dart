import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onMeters;
  final VoidCallback? onHistory;
  final VoidCallback? onAlerts;
  final VoidCallback? onSupport;

  const QuickActionsWidget({
    super.key,
    this.onMeters,
    this.onHistory,
    this.onAlerts,
    this.onSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acções rápidas',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.textColorDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickActionItem(
              icon: Icons.history_rounded,
              label: 'Histórico',
              onTap: onHistory,
            ),
              _QuickActionItem(
                icon: Icons.bolt_rounded,
                label: 'Contadores',
                onTap: onMeters,
              ),
              _QuickActionItem(
                icon: Icons.support_agent_rounded,
                label: 'Suporte',
                onTap: onSupport,
              ),
              _QuickActionItem(
                icon: Icons.notifications_active_outlined,
                label: 'Alertas',
                onTap: onAlerts,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.lightOrangeBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.textColorDark,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
