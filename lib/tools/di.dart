import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationService({required this.navigatorKey});

  Future<dynamic> pushNamed(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  void goBack() => navigatorKey.currentState!.pop();
}

void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService(navigatorKey: navigatorKey));

  // Only setup Bluetooth printer if a printer has been configured
  final printer = PreferencesData.getPrinter();
  if(printer.name.isNotEmpty && printer.connectionType == PrinterConnectionType.bluetooth){
    try {
      getIt.registerLazySingleton(() => BtPrint());
      getIt<BtPrint>().stateInfo();
    } catch (e) {
      // Bluetooth printer initialization failed, continue without it
    }
  }
}

class BtPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  
  void stateInfo(){
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          // showToastWarning("bluetooth device state: connected");
          break;
        case BlueThermalPrinter.DISCONNECTED:
          showToastWarning("bluetooth device state: disconnected");
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          showToastWarning("bluetooth device state: disconnect requested");
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          showToastWarning("bluetooth device state: bluetooth turning off");
          break;
        case BlueThermalPrinter.STATE_OFF:
          showToastWarning("bluetooth device state: bluetooth off");
          break;
        case BlueThermalPrinter.STATE_ON:
          showToastWarning("bluetooth device state: bluetooth on");
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          showToastWarning("bluetooth device state: bluetooth turning on");
          break;
        case BlueThermalPrinter.ERROR:
          showToastWarning("bluetooth device state: error");
          break;
        default:
          showToastWarning(state.toString());
          break;
      }
    });
  }

  Future<BlueThermalPrinter> getInstance() async {
    bool connectionState = await bluetooth.isConnected ?? false;
    PrinterModel printerDevice = PreferencesData.getPrinter();
    try {
      if (connectionState) {
        return bluetooth;
      } else {
        await bluetooth.connect(BluetoothDevice(printerDevice.name, printerDevice.address));
        return bluetooth;
      }
    } catch (error) {
      showToastError('Belum Siap\nPastikan Bluetooth Aktif, Printer Aktif dan Setting printer sesuai');
      return bluetooth;
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      bool connectionState = await bluetooth.isConnected ?? false;
      if (connectionState) {
        await bluetooth.disconnect();
      }
      await bluetooth.connect(device);
    } catch (error) {
      showToastError("Perangkat tidak aktif");
    }
  }

  Future<void> disconnectFromDevice() async {
    try {
      await bluetooth.disconnect();
    } catch (error) {
      showToastError("Disconnection failed: $error");
    }
  }
}
