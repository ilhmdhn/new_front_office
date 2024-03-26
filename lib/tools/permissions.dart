import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Permissions{
  void getNotificationPermission(){
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation< AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }
}