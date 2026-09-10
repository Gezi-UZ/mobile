import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // Request permissions
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showLowBalanceNotification(double balance) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'gezi_alerts_channel',
      'Gezi Alerts',
      channelDescription: 'Alertas importantes como saldo baixo',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'Saldo Baixo!',
      body:
          'O seu saldo é de apenas ${balance.toStringAsFixed(1)} kWh. Recarregue antes que fique sem energia.',
      notificationDetails: details,
      payload: 'low_balance',
    );
  }

  /// Notificação local para o estado de uma recarga (sucesso, falha, etc.)
  /// Chamada quando o utilizador está fora do ecrã de status e a recarga muda de estado.
  Future<void> showRechargeStatusNotification({
    required String title,
    required String body,
    required String rechargeId,
    required String status,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'gezi_recharge_channel',
      'Recargas Gezi',
      channelDescription: 'Notificações de estado das suas recargas',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'recarga',
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    // ID baseado no hashCode do rechargeId para evitar duplicados
    final int notifId = rechargeId.hashCode.abs() % 100000 + 1000;

    await flutterLocalNotificationsPlugin.show(
      id: notifId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: 'recharge_status:$rechargeId:$status',
    );
  }
}
