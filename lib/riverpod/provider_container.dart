import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global ProviderContainer untuk akses provider di luar widget
/// Gunakan ini untuk mengakses provider dari class biasa, model, atau service
class GlobalProviders {
  static ProviderContainer? _container;

  /// Inisialisasi container (dipanggil di main.dart)
  static void initialize(ProviderContainer container) {
    _container = container;
  }

  /// Mendapatkan instance container
  static ProviderContainer get instance {
    if (_container == null) {
      throw Exception(
        'ProviderContainer belum diinisialisasi. '
        'Pastikan GlobalProviders.initialize() dipanggil di main.dart',
      );
    }
    return _container!;
  }

  /// Helper method untuk read provider
  static T read<T>(ProviderListenable<T> provider) {
    return instance.read(provider);
  }
}
