import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/injection_container.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/alert.dart';
import '../bloc/alert_bloc.dart';
import '../bloc/alert_event.dart';
import '../bloc/alert_state.dart';
import '../widgets/alert_toggle_item.dart';
import '../widgets/notification_card.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AlertBloc>(),
      child: const _AlertsView(),
    );
  }
}

class _AlertsView extends StatefulWidget {
  const _AlertsView();

  @override
  State<_AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<_AlertsView> {
  // Toggles — serão carregados do backend futuramente
  bool _lowBalanceEnabled = true;
  bool _rechargeConfirmedEnabled = true;
  bool _paymentFailedEnabled = true;

  @override
  void initState() {
    super.initState();
    // Garante que o stream está activo quando entramos na página
    final bloc = context.read<AlertBloc>();
    if (bloc.state is AlertInitial) {
      bloc.add(const AlertWatchStarted());
    }
    // Marca todas as notificações como lidas ao abrir a tela
    bloc.add(const AlertMarkAllReadRequested());
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'agora mesmo';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours} horas';
    if (diff.inDays == 1) return 'ontem';
    if (diff.inDays < 7) return 'há ${diff.inDays} dias';
    return DateFormat('dd MMM', 'pt_PT').format(dt);
  }

  _NotificationStyle _styleForType(NotificationType type) {
    switch (type) {
      case NotificationType.rechargeSuccess:
        return _NotificationStyle(
          icon: Icons.check_circle_outline,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF22C55E),
        );
      case NotificationType.rechargeFailed:
        return _NotificationStyle(
          icon: Icons.error_outline,
          iconBg: const Color(0xFFFFE2E2),
          iconColor: const Color(0xFFEF4444),
        );
      case NotificationType.rechargeStatus:
        return _NotificationStyle(
          icon: Icons.bolt_outlined,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFF59E0B),
        );
      case NotificationType.lowBalance:
        return _NotificationStyle(
          icon: Icons.warning_amber_rounded,
          iconBg: const Color(0xFFFEF9C2),
          iconColor: const Color(0xFFEAB308),
        );
      case NotificationType.system:
        return _NotificationStyle(
          icon: Icons.info_outline,
          iconBg: const Color(0xFFE0F2FE),
          iconColor: const Color(0xFF0EA5E9),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          BlocBuilder<AlertBloc, AlertState>(
            builder: (context, state) {
              final hasUnread = state is AlertLoaded && state.unreadCount > 0;
              if (!hasUnread) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  context.read<AlertBloc>().add(const AlertMarkAllReadRequested());
                },
                child: Text(
                  'Marcar todas',
                  style: TextStyle(
                    color: AppTheme.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alertas',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              // ── CONFIGURAR ALERTAS ──────────────────────────────────
              Text(
                'CONFIGURAR ALERTAS',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: 0.30,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 0.88,
                  ),
                ),
                child: Column(
                  children: [
                    AlertToggleItem(
                      title: 'Saldo baixo',
                      value: _lowBalanceEnabled,
                      onChanged: (v) => setState(() => _lowBalanceEnabled = v),
                    ),
                    AlertToggleItem(
                      title: 'Recarga confirmada',
                      value: _rechargeConfirmedEnabled,
                      onChanged: (v) => setState(() => _rechargeConfirmedEnabled = v),
                    ),
                    AlertToggleItem(
                      title: 'Falha de pagamento',
                      value: _paymentFailedEnabled,
                      onChanged: (v) => setState(() => _paymentFailedEnabled = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── NOTIFICAÇÕES RECENTES ──────────────────────────────
              Text(
                'NOTIFICAÇÕES RECENTES',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: 0.30,
                ),
              ),
              const SizedBox(height: 12),

              BlocBuilder<AlertBloc, AlertState>(
                builder: (context, state) {
                  if (state is AlertLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryOrange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  if (state is AlertError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'Erro ao carregar alertas.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is AlertLoaded) {
                    if (state.notifications.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                size: 48,
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Sem notificações',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: state.notifications.map((notification) {
                        final style = _styleForType(notification.type);
                        return NotificationCard(
                          title: notification.title,
                          description: notification.body,
                          time: _formatTime(notification.createdAt),
                          icon: style.icon,
                          iconBackgroundColor: style.iconBg,
                          iconColor: style.iconColor,
                          isRead: notification.isRead,
                          onTap: notification.isRead
                              ? null
                              : () {
                                  context.read<AlertBloc>().add(
                                    AlertMarkReadRequested(notification.id),
                                  );
                                },
                        );
                      }).toList(),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationStyle {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _NotificationStyle({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}
