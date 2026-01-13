import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/login_response.dart';
import 'package:front_office_2/riverpod/provider_container.dart';
import 'package:front_office_2/tools/preferences.dart';

// Provider untuk User Data
final userProvider = StateNotifierProvider<UserNotifier, UserDataModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserDataModel> {
  UserNotifier() : super(_initialUser()) {
    _loadUser();
  }

  static UserDataModel _initialUser() {
    return PreferencesData.getUser();
  }

  void _loadUser() {
    state = PreferencesData.getUser();
  }

  Future<void> setUser(UserDataModel userData) async {
    await PreferencesData.setUser(userData);
    state = userData;

    // Invalidate userTokenProvider agar di-refresh dengan nilai baru
    try {
      GlobalProviders.invalidate(userTokenProvider);
    } catch (e) {
      // Jika dipanggil dari widget context, tidak perlu invalidate manual
    }
  }

  void refresh() {
    _loadUser();

    // Invalidate userTokenProvider agar di-refresh dengan nilai baru
    try {
      GlobalProviders.invalidate(userTokenProvider);
    } catch (e) {
      // Jika dipanggil dari widget context, tidak perlu invalidate manual
    }
  }

  String getToken() {
    return state.token;
  }
}

// Provider untuk Login State
final loginStateProvider = StateNotifierProvider<LoginStateNotifier, bool>((ref) {
  return LoginStateNotifier();
});

class LoginStateNotifier extends StateNotifier<bool> {
  LoginStateNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getLoginState();
  }

  void _loadState() {
    state = PreferencesData.getLoginState();
  }

  void setLoginState(bool value) {
    PreferencesData.setLoginState(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk Biometric Login State
final biometricLoginProvider = StateNotifierProvider<BiometricLoginNotifier, bool>((ref) {
  return BiometricLoginNotifier();
});

class BiometricLoginNotifier extends StateNotifier<bool> {
  BiometricLoginNotifier() : super(_initialState()) {
    _loadState();
  }

  static bool _initialState() {
    return PreferencesData.getBiometricLoginState();
  }

  void _loadState() {
    state = PreferencesData.getBiometricLoginState();
  }

  void setBiometricLogin(bool value) {
    PreferencesData.setBiometricLogin(value);
    state = value;
  }

  void refresh() {
    _loadState();
  }
}

// Provider untuk User Token saja
final userTokenProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider);
  return user.token;
});
