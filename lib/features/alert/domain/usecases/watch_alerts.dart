import '../entities/alert.dart';
import '../repositories/alert_repository.dart';

/// Use case que retorna um Stream de notificações via Supabase Realtime.
class WatchAlerts {
  final AlertRepository repository;

  WatchAlerts(this.repository);

  Stream<List<AppNotification>> call() => repository.watchNotifications();
}
