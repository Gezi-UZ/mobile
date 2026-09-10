import 'package:equatable/equatable.dart';
import '../../domain/entities/alert.dart';

abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

class AlertInitial extends AlertState {
  const AlertInitial();
}

class AlertLoading extends AlertState {
  const AlertLoading();
}

class AlertLoaded extends AlertState {
  final List<AppNotification> notifications;
  final int unreadCount;

  const AlertLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class AlertError extends AlertState {
  final String message;
  const AlertError(this.message);

  @override
  List<Object?> get props => [message];
}
