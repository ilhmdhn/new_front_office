import 'dart:async';
import 'package:flutter/services.dart';

/// Service untuk print via BLE (Bluetooth Low Energy)
/// Support Android & iOS
///
/// Workflow:
/// 1. Simpan device address
/// 2. Saat print: connect → discover → write → disconnect
class BlePrintService {
  static const MethodChannel _channel = MethodChannel('ble_print_service');

  final String deviceId;
  final String deviceName;

  // UUID untuk ESC/POS printer (standard)
  // Service UUID: 49535343-FE7D-4AE5-8FA9-9FAFD205E455
  // Write Characteristic: 49535343-8841-43F4-A8D4-ECBE34729BB3
  static const String serviceUuid = '49535343-FE7D-4AE5-8FA9-9FAFD205E455';
  static const String writeCharUuid = '49535343-8841-43F4-A8D4-ECBE34729BB3';

  BlePrintService({
    required this.deviceId,
    required this.deviceName,
  });

  /// Send ESC/POS data ke BLE Printer
  ///
  /// Workflow:
  /// 1. Connect ke device
  /// 2. Discover services & characteristics
  /// 3. Write data per chunk (max 512 bytes)
  /// 4. Disconnect
  ///
  /// Returns:
  /// - `true` jika berhasil terkirim
  /// - `false` jika gagal
  Future<bool> send(List<int> escPosData) async {
    if (escPosData.isEmpty) {
      throw ArgumentError('ESC/POS data tidak boleh kosong');
    }

    try {
      print('[BlePrint] Sending ${escPosData.length} bytes to $deviceName');

      // Send via method channel
      // Native side akan handle: connect → discover → write → disconnect
      final result = await _channel.invokeMethod('send', {
        'deviceId': deviceId,
        'data': Uint8List.fromList(escPosData),
        'serviceUuid': serviceUuid,
        'writeCharUuid': writeCharUuid,
      });

      print('[BlePrint] Send result: $result');
      return result == true;
    } on PlatformException catch (e) {
      print('[BlePrint] Platform error: ${e.message}');
      throw PlatformException(
        code: e.code,
        message: 'BLE print error: ${e.message}',
      );
    } catch (e) {
      print('[BlePrint] Unexpected error: $e');
      rethrow;
    }
  }

  /// Static method untuk one-time print tanpa create instance
  ///
  /// Example:
  /// ```dart
  /// await BlePrintService.printOnce(
  ///   deviceId: '12:34:56:78:AB:CD',
  ///   deviceName: 'Printer-BLE',
  ///   data: escPosBytes,
  /// );
  /// ```
  static Future<bool> printOnce({
    required String deviceId,
    required String deviceName,
    required List<int> data,
    String? serviceUuid,
    String? writeCharUuid,
  }) async {
    try {
      print('[BlePrint] Print once to $deviceName');

      final result = await _channel.invokeMethod('send', {
        'deviceId': deviceId,
        'data': Uint8List.fromList(data),
        'serviceUuid': serviceUuid ?? BlePrintService.serviceUuid,
        'writeCharUuid': writeCharUuid ?? BlePrintService.writeCharUuid,
      });

      return result == true;
    } on PlatformException catch (e) {
      print('[BlePrint] Print once error: ${e.message}');
      return false;
    }
  }

  /// Scan untuk BLE devices
  ///
  /// Duration: berapa lama scan (default 5 detik)
  ///
  /// Returns list of devices: [{'name': 'Printer', 'id': 'XX:XX:XX'}]
  static Future<List<Map<String, String>>> scanDevices({
    Duration scanDuration = const Duration(seconds: 5),
  }) async {
    try {
      print('[BlePrint] Scanning for ${scanDuration.inSeconds} seconds...');

      final result = await _channel.invokeMethod('scanDevices', {
        'duration': scanDuration.inMilliseconds,
      });

      if (result is List) {
        return result.map((device) {
          return {
            'name': device['name']?.toString() ?? 'Unknown',
            'id': device['id']?.toString() ?? '',
          };
        }).toList();
      }

      return [];
    } on PlatformException catch (e) {
      print('[BlePrint] Scan error: ${e.message}');
      return [];
    }
  }

  /// Stop scanning
  static Future<void> stopScan() async {
    try {
      await _channel.invokeMethod('stopScan');
      print('[BlePrint] Scan stopped');
    } on PlatformException catch (e) {
      print('[BlePrint] Stop scan error: ${e.message}');
    }
  }

  /// Check apakah Bluetooth enabled
  static Future<bool> isBluetoothEnabled() async {
    try {
      final result = await _channel.invokeMethod('isBluetoothEnabled');
      return result == true;
    } on PlatformException catch (e) {
      print('[BlePrint] Check bluetooth error: ${e.message}');
      return false;
    }
  }

  /// Request enable Bluetooth
  /// iOS: Akan show alert ke user untuk enable
  /// Android: Bisa enable programmatically (butuh permission)
  static Future<bool> enableBluetooth() async {
    try {
      final result = await _channel.invokeMethod('enableBluetooth');
      return result == true;
    } on PlatformException catch (e) {
      print('[BlePrint] Enable bluetooth error: ${e.message}');
      return false;
    }
  }

  /// Connect ke device (manual connect tanpa print)
  ///
  /// Returns `true` jika berhasil connect
  Future<bool> connect() async {
    try {
      print('[BlePrint] Connecting to $deviceName');

      final result = await _channel.invokeMethod('connect', {
        'deviceId': deviceId,
      });

      print('[BlePrint] Connect result: $result');
      return result == true;
    } on PlatformException catch (e) {
      print('[BlePrint] Connect error: ${e.message}');
      return false;
    }
  }

  /// Disconnect dari device
  Future<bool> disconnect() async {
    try {
      print('[BlePrint] Disconnecting from $deviceName');

      final result = await _channel.invokeMethod('disconnect', {
        'deviceId': deviceId,
      });

      print('[BlePrint] Disconnect result: $result');
      return result == true;
    } on PlatformException catch (e) {
      print('[BlePrint] Disconnect error: ${e.message}');
      return false;
    }
  }

  /// Check apakah device sedang connected
  Future<bool> isConnected() async {
    try {
      final result = await _channel.invokeMethod('isConnected', {
        'deviceId': deviceId,
      });
      return result == true;
    } on PlatformException catch (e) {
      print('[BlePrint] isConnected error: ${e.message}');
      return false;
    }
  }

  @override
  String toString() => 'BlePrintService(name: $deviceName, id: $deviceId)';
}
