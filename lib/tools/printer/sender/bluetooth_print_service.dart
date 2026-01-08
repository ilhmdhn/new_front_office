import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service untuk print via Bluetooth menggunakan Platform Channel
/// Mengirim ESC/POS commands langsung ke printer Bluetooth
///
/// Requires native implementation:
/// - Android: BluetoothPrintPlugin.kt
/// - iOS: BluetoothPrintPlugin.swift
class BluetoothPrintService {
  static const MethodChannel _channel = MethodChannel('bluetooth_print_service');

  final String deviceAddress;
  final String deviceName;

  BluetoothPrintService({
    required this.deviceAddress,
    required this.deviceName,
  });

  /// Send ESC/POS data ke Bluetooth Printer
  ///
  /// Returns:
  /// - `true` jika berhasil terkirim
  /// - `false` jika gagal
  ///
  /// Throws:
  /// - `PlatformException` jika terjadi error di native side
  Future<bool> send(List<int> escPosData) async {
    if (escPosData.isEmpty) {
      throw ArgumentError('ESC/POS data tidak boleh kosong');
    }

    try {
      debugPrint('[BluetoothPrint] Sending ${escPosData.length} bytes to $deviceName');

      final result = await _channel.invokeMethod('send', {
        'address': deviceAddress,
        'data': Uint8List.fromList(escPosData),
      });

      debugPrint('[BluetoothPrint] Send result: $result');
      return result == true;
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] Platform error: ${e.message}');
      throw PlatformException(
        code: e.code,
        message: 'Bluetooth print error: ${e.message}',
      );
    } catch (e) {
      debugPrint('[BluetoothPrint] Unexpected error: $e');
      rethrow;
    }
  }

  /// Static method untuk one-time print tanpa create instance
  ///
  /// Example:
  /// ```dart
  /// await BluetoothPrintService.printOnce(
  ///   address: 'DC:0D:30:12:34:56',
  ///   name: 'Printer-BT',
  ///   data: escPosBytes,
  /// );
  /// ```
  static Future<bool> printOnce({
    required String address,
    required String name,
    required List<int> data,
  }) async {
    final service = BluetoothPrintService(
      deviceAddress: address,
      deviceName: name,
    );
    return await service.send(data);
  }

  /// Connect ke Bluetooth device
  ///
  /// Returns `true` jika berhasil connect
  Future<bool> connect() async {
    try {
      debugPrint('[BluetoothPrint] Connecting to $deviceName ($deviceAddress)');

      final result = await _channel.invokeMethod('connect', {
        'address': deviceAddress,
      });

      debugPrint('[BluetoothPrint] Connect result: $result');
      return result == true;
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] Connect error: ${e.message}');
      return false;
    }
  }

  /// Disconnect dari Bluetooth device
  Future<bool> disconnect() async {
    try {
      debugPrint('[BluetoothPrint] Disconnecting from $deviceName');

      final result = await _channel.invokeMethod('disconnect', {
        'address': deviceAddress,
      });

      debugPrint('[BluetoothPrint] Disconnect result: $result');
      return result == true;
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] Disconnect error: ${e.message}');
      return false;
    }
  }

  /// Check apakah device sedang connected
  Future<bool> isConnected() async {
    try {
      final result = await _channel.invokeMethod('isConnected', {
        'address': deviceAddress,
      });
      return result == true;
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] isConnected error: ${e.message}');
      return false;
    }
  }

  /// Scan untuk Bluetooth devices yang tersedia
  ///
  /// Returns list of devices: [{'name': 'Printer', 'address': 'XX:XX:XX'}]
  static Future<List<Map<String, String>>> scanDevices() async {
    try {
      debugPrint('[BluetoothPrint] Scanning for devices...');

      final result = await _channel.invokeMethod('scanDevices');

      if (result is List) {
        return result.map((device) {
          return {
            'name': device['name']?.toString() ?? 'Unknown',
            'address': device['address']?.toString() ?? '',
          };
        }).toList();
      }

      return [];
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] Scan error: ${e.message}');
      return [];
    }
  }

  /// Get paired Bluetooth devices
  ///
  /// Returns list of paired devices
  static Future<List<Map<String, String>>> getPairedDevices() async {
    try {
      debugPrint('[BluetoothPrint] Getting paired devices...');

      final result = await _channel.invokeMethod('getPairedDevices');

      if (result is List) {
        return result.map((device) {
          return {
            'name': device['name']?.toString() ?? 'Unknown',
            'address': device['address']?.toString() ?? '',
          };
        }).toList();
      }

      return [];
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] Get paired devices error: ${e.message}');
      return [];
    }
  }

  /// Check apakah Bluetooth enabled
  static Future<bool> isBluetoothEnabled() async {
    try {
      final result = await _channel.invokeMethod('isBluetoothEnabled');
      return result == true;
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] Check bluetooth error: ${e.message}');
      return false;
    }
  }

  /// Request enable Bluetooth (Android only)
  static Future<bool> enableBluetooth() async {
    try {
      final result = await _channel.invokeMethod('enableBluetooth');
      return result == true;
    } on PlatformException catch (e) {
      debugPrint('[BluetoothPrint] Enable bluetooth error: ${e.message}');
      return false;
    }
  }

  @override
  String toString() => 'BluetoothPrintService(name: $deviceName, address: $deviceAddress)';
}
