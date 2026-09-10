import '../entities/alert.dart';

abstract class AlertRepository {
  /// Stream de notificações do utilizador actual (Supabase Realtime).
  Stream<List<AppNotification>> watchNotifications();

  /// Número de notificações não lidas.
  Future<int> getUnreadCount();

  /// Marca uma notificação como lida.
  Future<void> markAsRead(String id);

  /// Marca todas as notificações como lidas.
  Future<void> markAllAsRead();
}
