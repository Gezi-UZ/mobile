import 'package:equatable/equatable.dart';

enum NotificationType {
  rechargeSuccess,
  rechargeFailed,
  rechargeStatus,
  lowBalance,
  system;

  static NotificationType fromString(String value) {
    switch (value) {
      case 'recharge_success':
        return NotificationType.rechargeSuccess;
      case 'recharge_failed':
        return NotificationType.rechargeFailed;
      case 'recharge_status':
        return NotificationType.rechargeStatus;
      case 'low_balance':
        return NotificationType.lowBalance;
      default:
        return NotificationType.system;
    }
  }
}

class AppNotification extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.metadata,
    required this.createdAt,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      metadata: metadata,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, type, title, body, isRead, metadata, createdAt];
}
