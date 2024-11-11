import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

class FirebaseTools{
  static Future<void> initToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    PreferencesData.setFcmToken(fcmToken??'');

    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) async {
          PreferencesData.setFcmToken(fcmToken);
        })
        .onError((err) async {
          showToastError('Gagal Generate Token ${err.toString()}');
        });
  }
}