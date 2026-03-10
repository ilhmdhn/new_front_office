import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/request/api_request.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/tools/preferences.dart';


// Provider untuk FCM Token saat berhasil login
final fcmTokenProvider = StateNotifierProvider<FcmTokenNotifier, String>((ref) {
  return FcmTokenNotifier();
});

class FcmTokenNotifier extends StateNotifier<String> {

  FcmTokenNotifier() : super('');
  bool _isListening = false;
  
  Future<void> refresh() async {
    String? token = await _waitToken();
    if (token != null) {
      state = token;
      listenRefresh();
    }
  }


  Future<String?> _waitToken() async {
    for (int i = 0; i < 10; i++) {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return null;
  }

  void listenRefresh() {

    if (_isListening) return;
    _isListening = true;

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      state = newToken;
      ApiRequest().tokenPost();
      CloudRequest.insertLogin();
    });
  }

  Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
    state = '';
  }
}

// FutureProvider untuk IMEI (karena async)
final imeiProvider = FutureProvider<String>((ref) async {
  return await PreferencesData.getImei();
});

// StateNotifierProvider untuk Device Model (di-load saat app start)
final deviceModelProvider = StateNotifierProvider<DeviceModelNotifier, String>((ref) {
  return DeviceModelNotifier();
});

class DeviceModelNotifier extends StateNotifier<String> {
  DeviceModelNotifier() : super('') {
    _loadDeviceModel();
  }

  Future<void> _loadDeviceModel() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceModel = '';
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.utsname.machine;
    }
    state = deviceModel;
  }

  void refresh() {
    _loadDeviceModel();
  }
}

// FutureProvider untuk Device Model (jika masih diperlukan untuk async access)
final deviceModelAsyncProvider = FutureProvider<String>((ref) async {
  final deviceInfo = DeviceInfoPlugin();
  String deviceModel = '';
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    deviceModel = androidInfo.model;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceModel = iosInfo.utsname.machine;
  }
  return deviceModel;
});
