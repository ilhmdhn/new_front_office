import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/network.dart';
import 'package:front_office_2/tools/preferences.dart';

// Provider untuk BaseUrlModel (IP dan Port)
final serverConfigProvider = StateNotifierProvider<ServerConfigNotifier, BaseUrlModel>((ref) {
  return ServerConfigNotifier();
});

class ServerConfigNotifier extends StateNotifier<BaseUrlModel> {
  ServerConfigNotifier() : super(_initialConfig()) {
    _loadConfig();
  }

  static BaseUrlModel _initialConfig() {
    return PreferencesData.getConfigUrl();
  }

  void _loadConfig() {
    state = PreferencesData.getConfigUrl();
  }

  Future<void> updateConfig({required String ip, required String port}) async {
    final newConfig = BaseUrlModel(ip: ip, port: port);
    await PreferencesData.setUrl(newConfig);
    state = newConfig;
  }

  void refresh() {
    _loadConfig();
  }
}

// Provider untuk full URL string
final serverUrlProvider = Provider<String>((ref) {
  return PreferencesData.getUrl();
});

// Provider untuk outlet code
final outletProvider = StateNotifierProvider<OutletNotifier, String>((ref) {
  return OutletNotifier();
});

class OutletNotifier extends StateNotifier<String> {
  OutletNotifier() : super(_initialOutlet()) {
    _loadOutlet();
  }

  static String _initialOutlet() {
    return PreferencesData.getOutlet();
  }

  void _loadOutlet() {
    state = PreferencesData.getOutlet();
  }

  void updateOutlet(String outletCode) {
    PreferencesData.setOutlet(outletCode);
    state = outletCode;
  }

  void refresh() {
    _loadOutlet();
  }
}
