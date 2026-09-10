import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/alert/presentation/bloc/alert_bloc.dart';
import 'package:gezi/features/alert/presentation/bloc/alert_state.dart';

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
              color: Theme.of(context).colorScheme.onSurface,
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
                icon: Icons.electric_meter_outlined,
                label: 'Contadores',
                onTap: onMeters,
              ),
              _QuickActionItem(
                icon: Icons.support_agent_rounded,
                label: 'Suporte',
                onTap: onSupport,
              ),
              // Item de Alertas com badge dinâmico via AlertBloc
              BlocBuilder<AlertBloc, AlertState>(
                builder: (context, state) {
                  final count = state is AlertLoaded ? state.unreadCount : 0;
                  return _QuickActionItem(
                    icon: Icons.notifications_active_outlined,
                    label: 'Alertas',
                    onTap: onAlerts,
                    badgeCount: count,
                  );
                },
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
  final int badgeCount;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryOrange,
                  size: 28,
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
