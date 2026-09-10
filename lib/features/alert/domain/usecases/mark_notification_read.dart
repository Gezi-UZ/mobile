import '../repositories/alert_repository.dart';

class MarkNotificationRead {
  final AlertRepository repository;
  MarkNotificationRead(this.repository);
  Future<void> call(String id) => repository.markAsRead(id);
}

class MarkAllNotificationsRead {
  final AlertRepository repository;
  MarkAllNotificationsRead(this.repository);
  Future<void> call() => repository.markAllAsRead();
}

class GetUnreadCount {
  final AlertRepository repository;
  GetUnreadCount(this.repository);
  Future<int> call() => repository.getUnreadCount();
}
