import 'dart:async';
import 'dart:io';

/// Service untuk print langsung ke LAN Printer via raw TCP Socket
/// Mengirim ESC/POS commands langsung ke printer network
class LanPrintService {
  final String ip;
  final int port;
  final Duration connectTimeout;
  final Duration writeTimeout;

  LanPrintService({
    required this.ip,
    required this.port,
    this.connectTimeout = const Duration(seconds: 5),
    this.writeTimeout = const Duration(seconds: 3),
  });

  /// Send ESC/POS data langsung ke LAN Printer
  ///
  /// Returns:
  /// - `true` jika berhasil terkirim
  /// - `false` jika gagal
  ///
  /// Throws:
  /// - `SocketException` jika connection gagal
  /// - `TimeoutException` jika timeout
  Future<bool> send(List<int> escPosData) async {
    if (escPosData.isEmpty) {
      throw ArgumentError('ESC/POS data tidak boleh kosong');
    }

    Socket? socket;

    try {
      // 1. Connect ke printer LAN
      socket = await Socket.connect(
        ip,
        port,
        timeout: connectTimeout,
      );

      print('[LanPrint] Connected to $ip:$port');

      // 2. Kirim ESC/POS data ke printer
      socket.add(escPosData);
      await socket.flush();

      print('[LanPrint] Sent ${escPosData.length} bytes');

      // 3. Tunggu sebentar untuk memastikan data sampai ke printer
      // LAN printer tidak perlu response, jadi langsung delay saja
      await Future.delayed(const Duration(milliseconds: 500));

      // 4. Close connection
      await socket.close();
      print('[LanPrint] Connection closed');

      return true;
    } on SocketException catch (e) {
      print('[LanPrint] Socket error: $e');
      throw SocketException(
        'Gagal connect ke printer LAN $ip:$port - ${e.message}',
      );
    } on TimeoutException catch (e) {
      print('[LanPrint] Timeout: $e');
      throw TimeoutException(
        'Timeout connect ke printer LAN $ip:$port',
        connectTimeout,
      );
    } catch (e) {
      print('[LanPrint] Unexpected error: $e');
      rethrow;
    } finally {
      socket?.destroy();
    }
  }

  /// Static method untuk one-time print tanpa create instance
  ///
  /// Example:
  /// ```dart
  /// await LanPrintService.printOnce(
  ///   ip: '192.168.1.100',
  ///   port: 9100,
  ///   data: escPosBytes,
  /// );
  /// ```
  static Future<bool> printOnce({
    required String ip,
    required int port,
    required List<int> data,
    Duration connectTimeout = const Duration(seconds: 5),
    Duration writeTimeout = const Duration(seconds: 3),
  }) async {
    final service = LanPrintService(
      ip: ip,
      port: port,
      connectTimeout: connectTimeout,
      writeTimeout: writeTimeout,
    );
    return await service.send(data);
  }

  /// Test connection ke LAN printer
  ///
  /// Returns `true` jika bisa connect, `false` jika gagal
  Future<bool> testConnection() async {
    Socket? socket;
    try {
      socket = await Socket.connect(
        ip,
        port,
        timeout: connectTimeout,
      );
      await socket.close();
      print('[LanPrint] Connection test SUCCESS to $ip:$port');
      return true;
    } catch (e) {
      print('[LanPrint] Connection test FAILED to $ip:$port - $e');
      return false;
    } finally {
      socket?.destroy();
    }
  }

  /// Parse IP dan Port dari address string
  ///
  /// Supports format:
  /// - "192.168.1.100" → ip: 192.168.1.100, port: defaultPort
  /// - "192.168.1.100:9100" → ip: 192.168.1.100, port: 9100
  static Map<String, dynamic> parseAddress(
    String address, {
    int defaultPort = 9100,
  }) {
    if (address.contains(':')) {
      // Format: 192.168.1.100:9100
      final parts = address.split(':');
      return {
        'ip': parts[0],
        'port': int.tryParse(parts[1]) ?? defaultPort,
      };
    } else {
      // Format: 192.168.1.100
      return {
        'ip': address,
        'port': defaultPort,
      };
    }
  }

  @override
  String toString() => 'LanPrintService(ip: $ip, port: $port)';
}
