import '../../domain/entities/alert.dart';

class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.body,
    required super.isRead,
    super.metadata,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic raw) {
      if (raw == null) return DateTime.now();
      final str = raw.toString().trim();
      if (str.isEmpty) return DateTime.now();
      if (!str.endsWith('Z') &&
          !str.contains('+') &&
          !RegExp(r'-\d{2}:\d{2}$').hasMatch(str)) {
        return (DateTime.tryParse('${str}Z') ?? DateTime.now()).toLocal();
      }
      return (DateTime.tryParse(str) ?? DateTime.now()).toLocal();
    }

    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: NotificationType.fromString(json['type'] as String? ?? 'system'),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'type': type.name,
        'title': title,
        'body': body,
        'is_read': isRead,
        'metadata': metadata,
        'created_at': createdAt.toIso8601String(),
      };
}
