import 'package:equatable/equatable.dart';
import '../../domain/entities/alert.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object?> get props => [];
}

/// Inicia o stream de notificações Realtime.
class AlertWatchStarted extends AlertEvent {
  const AlertWatchStarted();
}

/// Emitido internamente quando o Realtime emite novos dados.
class AlertsUpdated extends AlertEvent {
  final List<AppNotification> notifications;
  const AlertsUpdated(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

/// Marcar uma notificação específica como lida.
class AlertMarkReadRequested extends AlertEvent {
  final String id;
  const AlertMarkReadRequested(this.id);

  @override
  List<Object?> get props => [id];
}

/// Marcar todas as notificações como lidas.
class AlertMarkAllReadRequested extends AlertEvent {
  const AlertMarkAllReadRequested();
}
