import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/data/model/network.dart';
import 'package:front_office_2/riverpod/provider_container.dart';
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

    // Invalidate serverUrlProvider agar di-refresh dengan nilai baru
    try {
      GlobalProviders.invalidate(serverUrlProvider);
    } catch (e) {
      // Jika dipanggil dari widget context, tidak perlu invalidate manual
      // karena ref.watch sudah otomatis rebuild
    }
  }

  void refresh() {
    _loadConfig();
  }
}

// Provider untuk full URL string (reactive terhadap perubahan serverConfigProvider)
final serverUrlProvider = Provider<String>((ref) {
  final config = ref.watch(serverConfigProvider);
  return 'http://${config.ip}:${config.port}';
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
