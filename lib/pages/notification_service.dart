import 'dart:html';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';



class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    initialize();
  }

  Future<void> initialize() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print("Уведомления разрешены");
    } else {
      print("Уведомления запрещены");
    }
  }

  Future<void> sendPeriodicNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'notes009', // Идентификатор канала
      'Notes', // Имя канала
      importance: Importance.high,
      playSound: true, // Воспроизводить звук при уведомлении
      enableVibration: true, // Включить вибрацию при уведомлении
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0, // Идентификатор уведомления
      'Note',
      'This is your periodic notification content.',
      RepeatInterval.everyMinute, // Периодичность (каждая минута)
      platformChannelSpecifics,
      payload: 'your_payload_data', // Дополнительные данные (можно использовать для обработки нажатия)
    );
  }
}
