import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
  NotificationService._();

  final FlutterLocalNotificationsPlugin
  _plugin =
  FlutterLocalNotificationsPlugin();

  static const String _channelId =
      'kisan_queue_updates';

  static const String _channelName =
      'Kisan Queue Updates';

  Future<void> initialize() async {
    const androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings =
    InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initializationSettings,
    );

    final androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    const channel =
    AndroidNotificationChannel(
      _channelId,
      _channelName,
      description:
      'Farmer procurement and queue updates',
      importance: Importance.high,
    );

    await androidPlugin?.createNotificationChannel(
      channel,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails =
    AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription:
      'Kisan Queue procurement updates',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      id,
      title,
      body,
      details,
    );
  }

  Future<void> bookingConfirmed({
    required String token,
    required String date,
    required String time,
  }) async {
    await showNotification(
      id: token.hashCode,
      title: 'Slot Booked Successfully',
      body:
      'Token $token booked for $date at $time.',
    );
  }

  Future<void> processStepCompleted({
    required String token,
    required String step,
  }) async {
    await showNotification(
      id: '${token}_$step'.hashCode,
      title: 'Procurement Update',
      body:
      '$step completed for token $token.',
    );
  }

  Future<void> processCompleted({
    required String token,
  }) async {
    await showNotification(
      id: '${token}_completed'.hashCode,
      title: 'Process Completed',
      body:
      'Procurement process for token $token is completed.',
    );
  }

  Future<void> nextFarmerReady({
    required String token,
  }) async {
    await showNotification(
      id: '${token}_ready'.hashCode,
      title: 'Your Turn Has Arrived',
      body:
      'Token $token is ready. Please check in.',
    );
  }
}