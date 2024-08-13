import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:front_office_2/tools/input_formatter.dart';
import 'package:front_office_2/tools/preferences.dart';
import 'package:front_office_2/tools/toast.dart';

class PrinterPage extends StatefulWidget {
  static const nameRoute = '/printer';
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterList> listPrinter = List.empty(growable: true);
  PrinterList chosedPrinter = PrinterList(name: '', address: '');
  bool isScanProcess = false;
  TextEditingController tfIpPc = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String printerName = printer.name;
    // String printerConnection = printer.connection;
    // String printerAddress = printer.address;
    // String printerType = printer.type;

    PrinterModel printer = PreferencesData.getPrinter();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            'Printer Setting :',
            style: CustomTextStyle.titleAppBar(),
          ),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text('Current Printer ',
                    style: CustomTextStyle.blackMediumSize(18)),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child:
                        Text('Printer', style: CustomTextStyle.blackMedium()),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(':'),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(printer.name,
                        style: CustomTextStyle.blackMedium()),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Connection',
                        style: CustomTextStyle.blackMedium()),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(':'),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(printer.connection,
                        style: CustomTextStyle.blackMedium()),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child:
                        Text('Address', style: CustomTextStyle.blackMedium()),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(':'),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(printer.address,
                        style: CustomTextStyle.blackMedium()),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Printer Type',
                        style: CustomTextStyle.blackMedium()),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(':'),
                  ),
                  Expanded(
                      flex: 5,
                      child: Text(printer.type,
                          style: CustomTextStyle.blackMedium())),
                ],
              ),
              const SizedBox(
                height: 26,
              ),

              Align(
                alignment: Alignment.center,
                child: Text('Pilih Printer', style: CustomTextStyle.blackMediumSize(19)),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                  Text('PC Printer',
                        style: CustomTextStyle.blackMediumSize(16)),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Flexible(
                              child: TextField(
                            inputFormatters: [IPAddressInputFormatter()],
                            keyboardType: TextInputType.number,
                            controller: tfIpPc,
                            decoration:
                                CustomTextfieldStyle.normalHint('Ip Address'),
                          )),
                          const SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            onTap: () {
                              PreferencesData.setPrinter(PrinterModel(
                                  name: 'PC PRINTER',
                                  connection: '3',
                                  type: 'DOT MATRIX',
                                  address: tfIpPc.text));

                              setState(() {
                                printer = PreferencesData.getPrinter();
                              });
                            },
                            child: Container(
                              decoration: CustomContainerStyle.confirmButton(),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              child: Text(
                                'Simpan',
                                style: CustomTextStyle.whiteStandard(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),

/*
                InkWell(
                  onTap: (){
                  listPrinter.clear();
                  if(isScanProcess == true){
                    showToastWarning('Proses scan sedang berjalan');
                    return;
                  }

                  setState(() {
                    isScanProcess = true;
                  });

                  printerManager.startScan(const Duration(seconds: 4));

                  Future.delayed(const Duration(seconds: 5), () {
                    printerManager.scanResults.listen((printers) async {
                      for (var element in printers) {
                        if(isNotNullOrEmpty(element.name) && isNotNullOrEmpty(element.address)){
                          final availableName = listPrinter.where((elementSearch) => elementSearch.name == element.name);
                          final availableAddress = listPrinter.where((elementSearch) => elementSearch.address == element.address);
                          if(isNullOrEmpty(availableName) && isNullOrEmpty(availableAddress)){
                            listPrinter.add(PrinterList(name: element.name??'', address: element.address??''));
                          }
                        }
                      }
                    });

                    setState(() {
                      listPrinter;
                      isScanProcess = false;
                    });
                  });
                }, 
                
                child: isScanProcess == true?
                  Container(
                    decoration: CustomContainerStyle.blueButton(),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Text('Scanning...', style: CustomTextStyle.whiteStandard(),),
                  ):
                  Container(
                    decoration: CustomContainerStyle.confirmButton(),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Text('Scan Bluetooth printer', style: CustomTextStyle.whiteStandard(),),
                  )
                ),

          isNullOrEmpty(listPrinter)?
          const SizedBox():
          Text(listPrinter[0].name),
          const SizedBox(height: 20,),*/

              //   DropdownButton<PrinterList>(
              //   value: chosedPrinter,
              //   items: listPrinter.map((PrinterList item) {
              //     return DropdownMenuItem<PrinterList>(
              //       value: item,
              //       child: Text(item.name),
              //     );
              //   }).toList(),
              //   onChanged: (PrinterList? newValue) {
              //     setState(() {
              //       chosedPrinter = newValue!;
              //     });
              //   },
              // ),

              // DropdownButton(
              //         isExpanded: true,
              //         items: items,
              //         hint: isNullOrEmpty(listPrinter) ? const Text('No available devices') : null,
              //         onChanged: (PrinterList? value) {
              //           setState(() {
              //             chosedPrinter = PrinterList(
              //               name: value?.name??'',
              //               address: value?.address??''
              //             );
              //           });
              //         },
              //         value: chosedPrinter,
              // ),
/*                SizedBox(
                  width: double.infinity,
                  child: Text('Current Printer ', style: CustomTextStyle.blackMediumSize(18)),
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
                      child: Text(printer.name , style: CustomTextStyle.blackMedium()),
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
                      child: Text(printer.connection, style: CustomTextStyle.blackMedium()),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Address', style: CustomTextStyle.blackMedium()),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(':'),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(printer.address, style: CustomTextStyle.blackMedium()),
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
                      child: Text(printer.type, style: CustomTextStyle.blackMedium())
                    ),
                  ],
                ),
                const SizedBox(height: 26,),
                Text('Ganti Printer', style: CustomTextStyle.titleAlertDialog(), textAlign: TextAlign.center,),
                const SizedBox(height: 7,),
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
                        isExpanded: true,
                        items: _getDeviceItems(),
                        hint: isNullOrEmpty(_getDeviceItems()) ? const Text('No available devices') : null,
                        onChanged: (BluetoothDevice? value) {
                          setState(() {
                            _device = BluetoothDevice(
                              value?.name,
                              value?.address
                            );
                          });
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
                      style: CustomButtonStyle.bluePrimary(),
                      onPressed: () async{
                        // testPrint.sample();
                        String? anu = await SelectPrinterDialog().setPrinter(context, 'Portable 58mm');
                        showToastWarning(anu.toString());
                      },
                      child: const Text('Pilih Type',
                          style: TextStyle(color: Colors.white)),
                                        ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                      style: CustomButtonStyle.bluePrimary(),
                      onPressed: () {
                        showToastWarning('NGETEST');
                        testPrint.sample();
                      },
                      child: const Text('Print Test',
                          style: TextStyle(color: Colors.white)),
                                        ),
                    ),
                    const SizedBox(width: 10),
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
                  ],
                ),
               
                const SizedBox(height: 26,),
                ElevatedButton(
                  onPressed: (){
                    bluetooth.isConnected.then((isConnected) {
                      showToastWarning('STATUS KONEKSI $isConnected');
                    });
                  }, 
                  child: Text('konek'))
                /*
                SizedBox(
                  width: double.infinity,
                  child: Text('Setting Network Printer', style: CustomTextStyle.blackMedium(), textAlign: TextAlign.center,),
                ),
                const SizedBox(height: 12,),
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
                ),*/



                const SizedBox(height: 12,),
                Row(children: [
                  //nganu
                                      SizedBox(
                      height: 36,
                      child: ElevatedButton(
                      style: CustomButtonStyle.bluePrimary(),
                      onPressed: () async{
                        // testPrint.sample();
                        int? anu = await SelectPrinterDialog().setPrinter(context, 1);
                        showToastWarning(anu.toString());
                      },
                      child: const Text('Pilih Type',
                          style: TextStyle(color: Colors.white)),
                                        ),
                    ),
                    const SizedBox(width: 10,),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(onPressed: (){}, style: CustomButtonStyle.bluePrimary(), child: Text('Print Test', style: CustomTextStyle.whiteStandard(),)))
                ],),*/
            ],
          )),
        ),
      ),
    );
  }
/*
  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            showToastError(error.toString());
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
*/

_getDeviceItems() {
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

}
