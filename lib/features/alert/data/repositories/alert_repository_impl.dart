import '../../domain/entities/alert.dart';
import '../../domain/repositories/alert_repository.dart';
import '../datasources/alert_realtime_data_source.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertRealtimeDataSource dataSource;

  AlertRepositoryImpl({required this.dataSource});

  @override
  Stream<List<AppNotification>> watchNotifications() =>
      dataSource.watchNotifications();

  @override
  Future<int> getUnreadCount() => dataSource.getUnreadCount();

  @override
  Future<void> markAsRead(String id) => dataSource.markAsRead(id);

  @override
  Future<void> markAllAsRead() => dataSource.markAllAsRead();
}
