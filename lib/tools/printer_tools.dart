import 'dart:async';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/services.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/toast.dart';

class PrinterTools{
  // PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  Future<List<dynamic>> getBluetoothDevices() async {
    List<dynamic> devices = [];
    try {
      // devices = await printerManager.scanResults;
    } on PlatformException catch (e) {
      showToastError("Error getting list devices: ${e.toString()}");
    }
    return devices;
  }
}