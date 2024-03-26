import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front_office_2/page/extend/extend_room_page.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/toast.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  SendNotification.notif(message);
}

class SendNotification {

  static Future<void> onDidReceiveBackgroundNotificationResponse(NotificationResponse response) async {
    getIt<NavigationService>().pushNamedAndRemoveUntil(ExtendRoomPage.nameRoute);
    showToastWarning(response.payload.toString());
  }

  static Future<void> onDidReceiveNotificationResponse(NotificationResponse response) async {
    getIt<NavigationService>().pushNamedAndRemoveUntil(ExtendRoomPage.nameRoute);
        showToastWarning(response.payload.toString());
  }

  static void notif(RemoteMessage message) async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your_channel_name', 'your_channel_description',
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'New Notification', 'Hello, this is a notification!', platformChannelSpecifics,
        payload: '/room-extend');
  }
}
