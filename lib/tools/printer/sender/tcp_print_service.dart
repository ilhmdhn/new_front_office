import 'dart:async';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/data/model/print_job.dart';
import 'package:front_office_2/riverpod/printer/printer_job_provider.dart';
import 'package:front_office_2/riverpod/provider_container.dart';

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

  static Future<bool> printWithRetry({
    required String ip,
    required int port,
    required List<int> data,
    int maxRetry = 3,
    Duration connectTimeout = const Duration(seconds: 5),
    Duration responseTimeout = const Duration(seconds: 2),
  }) async {
    if (data.isEmpty) return false;
    String errorMessage = '';
    for (int attempt = 1; attempt <= maxRetry; attempt++) {
      try {
        debugPrint('[TcpPrinter] Attempt $attempt');

        final success = await TcpPrinterService.printOnce(
          ip: ip,
          port: port,
          data: data,
          connectTimeout: connectTimeout,
          responseTimeout: responseTimeout,
        );

        if (success) {
          debugPrint('[TcpPrinter] Success on attempt $attempt');
          return true;
        }
      } catch (e, stackTrace) {
        debugPrint('[TcpPrinter] Error on attempt $attempt: $e');
        errorMessage = '$e\n$stackTrace';
      }

      if (attempt < maxRetry) {
        final delayMs = 700 * attempt; // 700ms, 1400ms
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }

    debugPrint('[TcpPrinter] All retry failed');
    final printQueue = PrintJob(
      title: 'Gagal print tcp', 
      description: errorMessage,
      data: data, 
      printerType: PrinterConnectionType.lan, 
      target: ip,
      createdAt: DateTime.now()
    );
    GlobalProviders.read(printJobProvider.notifier).addJob(printQueue);
    return false;
  }

  /// Send ESC/POS data ke printer via TCP
  ///
  /// Returns:
  /// - `true` jika print berhasil
  /// - `false` jika print gagal
  ///
  /// Throws:
  /// - `SocketException` jika connection gagal
  /// - `TimeoutException` jika timeout
  /// - `Exception` untuk error lainnya
  Future<bool> send(List<int> escPosData) async {
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

      debugPrint('[TcpPrinter] Connected to $ip:$port');

      // 2. Kirim data ESC/POS
      socket.add(escPosData);
      await socket.flush();

      debugPrint('[TcpPrinter] Sent ${escPosData.length} bytes');

      // 3. Tunggu sebentar untuk memastikan data terkirim
      await Future.delayed(const Duration(milliseconds: 500));

      // 4. Close connection
      await socket.close();
      debugPrint('[TcpPrinter] Connection closed');

      return true;
    } on SocketException catch (e) {
      debugPrint('[TcpPrinter] Socket error: $e');
      throw SocketException(
        'Gagal connect ke printer $ip:$port - ${e.message}',
      );
    } on TimeoutException catch (e) {
      debugPrint('[TcpPrinter] Timeout: $e');
      throw TimeoutException(
        'Timeout connect ke printer $ip:$port',
        connectTimeout,
      );
    } catch (e) {
      debugPrint('[TcpPrinter] Unexpected error: $e');
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
    return await service.send(data);
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
      debugPrint('[TcpPrinter] Connection test SUCCESS to $ip:$port');
      return true;
    } catch (e) {
      debugPrint('[TcpPrinter] Connection test FAILED to $ip:$port - $e');
      return false;
    } finally {
      socket?.destroy();
    }
  }

  @override
  String toString() => 'TcpPrinterService(ip: $ip, port: $port)';
}
