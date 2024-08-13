import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:front_office_2/tools/toast.dart';

class PrinterTools{
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  
  Future<List<BluetoothDevice>> getBluetoothDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      showToastError("Error getting list devices: $e");
    }
    return devices;
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await bluetooth.connect(device);
    } catch (error) {
      showToastError("Connection failed: $error");
    }
  }

  void disconnectFromDevice() async {
    try {
      await bluetooth.disconnect();
    } catch (error) {
      showToastError("Disconnection failed: $error");
    }
  }
}