import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:front_office_2/page/setting/printer/test_print.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/input_formatter.dart';
import 'package:front_office_2/tools/printer_size.dart';
import 'package:front_office_2/tools/toast.dart';

class PrinterPage extends StatefulWidget {
  static const nameRoute = '/printer';
  const PrinterPage({super.key});
  
  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  TestPrint testPrint = TestPrint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      showToastError('Error list bluetooth printer');
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Printer Setting', style: CustomTextStyle.titleAppBar(),),
            backgroundColor: CustomColorStyle.appBarBackground(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Text('Current Printer:', style: CustomTextStyle.blackMedium()),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Printer', style: CustomTextStyle.blackMedium()),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(':'),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text('RPP02N Printer Bluetooth', style: CustomTextStyle.blackMedium()),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Connection', style: CustomTextStyle.blackMedium()),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(':'),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text('Bluetooth/ network', style: CustomTextStyle.blackMedium()),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Printer Type', style: CustomTextStyle.blackMedium()),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(':'),
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomRadioButton(
                        selectedBorderColor: Colors.transparent,
                        unSelectedBorderColor: Colors.transparent,
                        buttonLables: printerSizeList, 
                        buttonValues: printerCode,
                          buttonTextStyle: ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: Colors.black,
                          textStyle: CustomTextStyle.blackStandard()),
                        autoWidth: true, 
                        radioButtonValue: (value){
                          showToastWarning(value.toString());
                        }, 
                        unSelectedColor: Colors.white, 
                        selectedColor: CustomColorStyle.appBarBackground()),
                    ),
                  ],
                ),
                const SizedBox(height: 26,),
                SizedBox(
                  width: double.infinity,
                  child: Text('Pilih Bluetooth Printer', style: CustomTextStyle.blackMedium(), textAlign: TextAlign.center,),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Device:',
                        style: CustomTextStyle.blackSemi()
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        hint: isNullOrEmpty(_getDeviceItems()) ? const Text('No available devices') : null,
                        onChanged: (BluetoothDevice? value) {
                            setState(() => _device =BluetoothDevice(
                              'fix printer', 
                              '02:2A:9F:2C:37:48'
                              ));
                              },
                        value: _device,
                      ),
                    ),
                    const SizedBox(width: 10),
                     Expanded(
                      flex: 1,
                       child: SizedBox(
                        height: 36,
                         child: ElevatedButton(
                          style: CustomButtonStyle.bluePrimary(),
                          onPressed: () {
                            initPlatformState();
                          },
                          child: const Text(
                            'Refresh',
                            style: TextStyle(color: Colors.white),
                          ),
                                             ),
                       ),
                     ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        style: CustomButtonStyle.confirm(),
                        onPressed: _connected ? _disconnect : _connect,
                        child: Text(
                          _connected ? 'Disconnect' : 'Connect',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                      style: CustomButtonStyle.bluePrimary(),
                      onPressed: () {
                        testPrint.sample();
                      },
                      child: const Text('Print Test',
                          style: TextStyle(color: Colors.white)),
                                        ),
                    ),
                  ],
                ),
               
                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  child: Text('Setting Network Printer', style: CustomTextStyle.blackMedium(), textAlign: TextAlign.center,),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        decoration: CustomTextfieldStyle.normalHint('192.168.1.1'),
                        inputFormatters: [IPAddressInputFormatter()],
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      )
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: CustomTextfieldStyle.normalHint('9100'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      )
                    ),
                    const SizedBox(width: 14,),
                    ElevatedButton(
                      onPressed: (){}, 
                      style: CustomButtonStyle.confirm(),
                      child: const Text('Connect'))
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.clear();
    } else {
      for (var device in _devices) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(device.name.toString()),
        ));
      }
    }
    return items;
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    } else {
      showToastWarning('No device selected.');
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

}