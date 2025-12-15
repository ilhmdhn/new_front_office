import 'dart:convert';
import 'package:flutter/services.dart';

/// Helper class untuk load JSON files dari assets/dummy_responses
class DummyJsonLoader {
  static const String _basePath = 'assets/dummy_responses';

  /// Load JSON file dari assets
  ///
  /// Example:
  /// ```dart
  /// final json = await DummyJsonLoader.load('auth/login.json');
  /// ```
  static Future<Map<String, dynamic>> load(String filePath) async {
    try {
      final String jsonString = await rootBundle.loadString('$_basePath/$filePath');
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load dummy JSON: $filePath - Error: $e');
    }
  }

  /// Load JSON template dan replace placeholders
  ///
  /// Example:
  /// ```dart
  /// final json = await DummyJsonLoader.loadTemplate(
  ///   'room/room_list_template.json',
  ///   {'ROOM_TYPE': 'VIP'}
  /// );
  /// ```
  static Future<Map<String, dynamic>> loadTemplate(
    String filePath,
    Map<String, String> replacements,
  ) async {
    try {
      String jsonString = await rootBundle.loadString('$_basePath/$filePath');

      // Replace semua placeholders
      replacements.forEach((key, value) {
        jsonString = jsonString.replaceAll('{$key}', value);
      });

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load dummy JSON template: $filePath - Error: $e');
    }
  }

  /// Load JSON dan replace dengan timestamp
  ///
  /// Example:
  /// ```dart
  /// final json = await DummyJsonLoader.loadWithTimestamp('other/checkin_success.json');
  /// ```
  static Future<Map<String, dynamic>> loadWithTimestamp(String filePath) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final currentTime = DateTime.now().toString();

    return loadTemplate(filePath, {
      'TIMESTAMP': timestamp,
      'CURRENT_TIME': currentTime,
    });
  }

  /// Load JSON dan replace dengan dynamic room price based on room type
  static Future<Map<String, dynamic>> loadRoomList(String roomType) async {
    final json = await loadTemplate('room/room_list_template.json', {
      'ROOM_TYPE': roomType,
    });

    // Update room price based on type
    int price = 75000; // Default STANDARD
    if (roomType == 'VIP') {
      price = 150000;
    } else if (roomType == 'REGULAR') {
      price = 100000;
    }

    // Update all room prices in the list
    if (json['data'] is List) {
      for (var room in json['data']) {
        if (room is Map) {
          room['room_price'] = price;
        }
      }
    }

    return json;
  }

  /// Helper untuk get current datetime string
  static String getCurrentDateTime() {
    return DateTime.now().toString().substring(0, 19);
  }

  /// Helper untuk get timestamp
  static String getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
