import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:front_office_2/tools/di.dart';
import 'package:front_office_2/tools/toast.dart';

class PrinterTools{
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Future<List<BluetoothDevice>> getBluetoothDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      final bluetooth = await BtPrint().getInstance();
      devices = await bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      showToastError("Error getting list devices:");
    }
    return devices;
  }
}