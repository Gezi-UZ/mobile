import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/alert.dart';
import '../../domain/usecases/watch_alerts.dart';
import '../../domain/usecases/mark_notification_read.dart';
import 'alert_event.dart';
import 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final WatchAlerts watchAlerts;
  final MarkNotificationRead markNotificationRead;
  final MarkAllNotificationsRead markAllNotificationsRead;

  StreamSubscription<List<AppNotification>>? _notificationsSub;

  AlertBloc({
    required this.watchAlerts,
    required this.markNotificationRead,
    required this.markAllNotificationsRead,
  }) : super(const AlertInitial()) {
    on<AlertWatchStarted>(_onWatchStarted);
    on<AlertsUpdated>(_onAlertsUpdated);
    on<AlertMarkReadRequested>(_onMarkRead);
    on<AlertMarkAllReadRequested>(_onMarkAllRead);
  }

  Future<void> _onWatchStarted(
    AlertWatchStarted event,
    Emitter<AlertState> emit,
  ) async {
    emit(const AlertLoading());

    await _notificationsSub?.cancel();
    _notificationsSub = null;

    await emit.forEach<List<AppNotification>>(
      watchAlerts(),
      onData: (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        return AlertLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        );
      },
      onError: (error, _) => AlertError(error.toString()),
    );
  }

  Future<void> _onAlertsUpdated(
    AlertsUpdated event,
    Emitter<AlertState> emit,
  ) async {
    final unreadCount = event.notifications.where((n) => !n.isRead).length;
    emit(AlertLoaded(
      notifications: event.notifications,
      unreadCount: unreadCount,
    ));
  }

  Future<void> _onMarkRead(
    AlertMarkReadRequested event,
    Emitter<AlertState> emit,
  ) async {
    try {
      await markNotificationRead(event.id);
      // O stream Realtime vai actualizar automaticamente — não precisamos
      // de emitir um novo estado manualmente aqui.
    } catch (_) {
      // Falha silenciosa — o estado local não muda
    }
  }

  Future<void> _onMarkAllRead(
    AlertMarkAllReadRequested event,
    Emitter<AlertState> emit,
  ) async {
    try {
      await markAllNotificationsRead();
      // O stream Realtime actualizará automaticamente
    } catch (_) {
      // Falha silenciosa
    }
  }

  @override
  Future<void> close() async {
    await _notificationsSub?.cancel();
    return super.close();
  }
}
