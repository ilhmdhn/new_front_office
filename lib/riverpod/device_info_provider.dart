import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/tools/preferences.dart';


// Provider untuk FCM Token (di-load saat app start)
final fcmTokenProvider = StateNotifierProvider<FcmTokenNotifier, String>((ref) {
  return FcmTokenNotifier();
});

class FcmTokenNotifier extends StateNotifier<String> {
  FcmTokenNotifier() : super('') {
    _loadToken();
    _listenTokenRefresh();
  }

  Future<void> _loadToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      state = token;
    }
  }

  void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      state = newToken;
    });
  }

  Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
    state = '';
  }

  void refresh() {
    _loadToken();
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
