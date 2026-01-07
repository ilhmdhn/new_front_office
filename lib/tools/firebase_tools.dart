import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:front_office_2/riverpod/providers.dart';

import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class FirebaseTools{
  static Future<void> initToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((newtoken) async {
      fcmToken = newtoken;
    }).onError((err) async {
      showToastError('Gagal Generate Token ${err.toString()}');
    });
    if(isNotNullOrEmpty(fcmToken)){
      // GlobalProviders.read(fcmTokenProvider.notifier).setFcmToken(fcmToken!);
    }
  }
}