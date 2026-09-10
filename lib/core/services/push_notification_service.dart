import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_notification_service.dart';
import '../../injection_container.dart';

// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Here you can handle the background message.
}

class PushNotificationService {
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<void> init() async {
    // Request permission
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToDatabase(token);
      }

      // Listen to token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        _saveTokenToDatabase(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          final title = message.notification?.title ?? 'Alerta';
          final body = message.notification?.body ?? '';
          sl<LocalNotificationService>().flutterLocalNotificationsPlugin.show(
                id: message.hashCode,
                title: title,
                body: body,
                notificationDetails: const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'gezi_alerts_channel',
                    'Gezi Alerts',
                    channelDescription: 'Alertas importantes',
                    importance: Importance.max,
                    priority: Priority.high,
                  ),
                ),
              );
        }
      });
    }
  }

  Future<void> _saveTokenToDatabase(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final platform = Platform.isIOS ? 'ios' : 'android';
      // Upsert the token to the user_devices table
      await _supabase.from('user_devices').upsert({
        'user_id': user.id,
        'fcm_token': token,
        'platform': platform,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'fcm_token');
    } catch (e) {
      // Ignore if it fails
    }
  }
}
