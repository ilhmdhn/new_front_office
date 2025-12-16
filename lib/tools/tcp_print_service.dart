import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Service untuk print via TCP/IP raw socket
/// Compatible dengan Printer Forwarder (Windows) atau Network Printer
class TcpPrinterService {
  final String ip;
  final int port;
  final Duration connectTimeout;
  final Duration responseTimeout;

  TcpPrinterService({
    required this.ip,
    required this.port,
    this.connectTimeout = const Duration(seconds: 5),
    this.responseTimeout = const Duration(seconds: 2),
  });

  /// Print ESC/POS data ke printer via TCP
  ///
  /// Returns:
  /// - `true` jika print berhasil
  /// - `false` jika print gagal
  ///
  /// Throws:
  /// - `SocketException` jika connection gagal
  /// - `TimeoutException` jika timeout
  /// - `Exception` untuk error lainnya
  Future<bool> print(List<int> escPosData) async {
    if (escPosData.isEmpty) {
      throw ArgumentError('ESC/POS data tidak boleh kosong');
    }

    Socket? socket;

    try {
      // 1. Connect ke server
      socket = await Socket.connect(
        ip,
        port,
        timeout: connectTimeout,
      );

      print('[TcpPrinter] Connected to $ip:$port' as List<int>);

      // 2. Kirim data ESC/POS
      socket.add(escPosData);
      await socket.flush();

      print('[TcpPrinter] Sent ${escPosData.length} bytes' as List<int>);

      // 3. Tunggu response dari server (optional)
      try {
        final response = await socket
            .timeout(responseTimeout)
            .transform(const Utf8Decoder() as StreamTransformer<Uint8List, dynamic>)
            .first;

        final responseText = response.trim();
        print('[TcpPrinter] Server response: $responseText' as List<int>);

        if (responseText == 'OK') {
          print('[TcpPrinter] Print SUCCESS' as List<int>);
          return true;
        } else if (responseText == 'ERROR') {
          print('[TcpPrinter] Print FAILED (server error)' as List<int>);
          return false;
        }
      } on TimeoutException {
        // Timeout waiting for response is OK
        // Some printers don't send response
        print('[TcpPrinter] No response from server (timeout - this is OK)' as List<int>);
        return true;
      }

      // 4. Close connection
      await socket.close();
      print('[TcpPrinter] Connection closed' as List<int>);

      return true;
    } on SocketException catch (e) {
      print('[TcpPrinter] Socket error: $e' as List<int>);
      throw SocketException(
        'Gagal connect ke printer $ip:$port - ${e.message}',
      );
    } on TimeoutException catch (e) {
      print('[TcpPrinter] Timeout: $e' as List<int>);
      throw TimeoutException(
        'Timeout connect ke printer $ip:$port',
        connectTimeout,
      );
    } catch (e) {
      print('[TcpPrinter] Unexpected error: $e' as List<int>);
      rethrow;
    } finally {
      socket?.destroy();
    }
  }

  /// Static method untuk one-time print tanpa create instance
  ///
  /// Example:
  /// ```dart
  /// await TcpPrinterService.printOnce(
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
    Duration responseTimeout = const Duration(seconds: 2),
  }) async {
    final service = TcpPrinterService(
      ip: ip,
      port: port,
      connectTimeout: connectTimeout,
      responseTimeout: responseTimeout,
    );
    return await service.print(data);
  }

  /// Test connection ke printer (tidak print, hanya test connect)
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
      print('[TcpPrinter] Connection test SUCCESS to $ip:$port' as List<int>);
      return true;
    } catch (e) {
      print('[TcpPrinter] Connection test FAILED to $ip:$port - $e' as List<int>);
      return false;
    } finally {
      socket?.destroy();
    }
  }

  @override
  String toString() => 'TcpPrinterService(ip: $ip, port: $port)';
}
