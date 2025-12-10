import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

class FirebaseTools{
  static Future<void> initToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('DEBUGGING FCM Token: $fcmToken');

    FirebaseMessaging.instance.onTokenRefresh.listen((newtoken) async {
      fcmToken = newtoken;
    }).onError((err) async {
      showToastError('Gagal Generate Token ${err.toString()}');
    });
    if(isNotNullOrEmpty(fcmToken)){
      PreferencesData.setFcmToken(fcmToken!);
      ApiRequest().tokenPost(fcmToken!);    
    }
  }
}