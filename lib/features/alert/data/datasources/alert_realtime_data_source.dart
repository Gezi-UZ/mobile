import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/alert.dart';
import '../models/notification_model.dart';

abstract class AlertRealtimeDataSource {
  Stream<List<AppNotification>> watchNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class AlertRealtimeDataSourceImpl implements AlertRealtimeDataSource {
  SupabaseClient get _supabase => Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  @override
  Stream<List<AppNotification>> watchNotifications() {
    final uid = _userId;
    if (uid == null) {
      return const Stream.empty();
    }

    return _supabase
        .from('user_notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(50)
        .map((rows) => rows
            .map((row) => NotificationModel.fromJson(row))
            .toList());
  }

  @override
  Future<int> getUnreadCount() async {
    final uid = _userId;
    if (uid == null) return 0;

    final response = await _supabase
        .from('user_notifications')
        .select('id')
        .eq('user_id', uid)
        .eq('is_read', false);

    return (response as List).length;
  }

  @override
  Future<void> markAsRead(String id) async {
    final uid = _userId;
    if (uid == null) return;

    await _supabase
        .from('user_notifications')
        .update({'is_read': true})
        .eq('id', id)
        .eq('user_id', uid);
  }

  @override
  Future<void> markAllAsRead() async {
    final uid = _userId;
    if (uid == null) return;

    await _supabase
        .from('user_notifications')
        .update({'is_read': true})
        .eq('user_id', uid)
        .eq('is_read', false);
  }
}
