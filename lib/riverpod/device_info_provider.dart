import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/tools/preferences.dart';

// Provider untuk FCM Token
final fcmTokenProvider = StateNotifierProvider<FcmTokenNotifier, String>((ref) {
  return FcmTokenNotifier();
});

class FcmTokenNotifier extends StateNotifier<String> {
  FcmTokenNotifier() : super(_initialToken()) {
    _loadToken();
  }

  static String _initialToken() {
    return PreferencesData.getFcmToken();
  }

  void _loadToken() {
    state = PreferencesData.getFcmToken();
  }

  Future<void> setFcmToken(String token) async {
    await PreferencesData.setFcmToken(token);
    state = token;
  }

  void refresh() {
    _loadToken();
  }
}

// FutureProvider untuk IMEI (karena async)
final imeiProvider = FutureProvider<String>((ref) async {
  return await PreferencesData.getImei();
});

// FutureProvider untuk Device Model (karena async)
final deviceModelProvider = FutureProvider<String>((ref) async {
  return await PreferencesData.getDeviceModel();
});
