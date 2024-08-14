import 'package:auto_size_text/auto_size_text.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/data/model/other_model.dart';
import 'package:front_office_2/tools/btprint_executor.dart';
import 'package:front_office_2/tools/printer_tools.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/di.dart';
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
  List<PrinterList> listPrinter = List.empty(growable: true);
  PrinterList chosedPrinter = PrinterList(name: '', address: '');
  bool isScanProcess = false;
  TextEditingController tfIpPc = TextEditingController();
  List<BluetoothDevice> printerList = List.empty(growable: true);
  PrinterModel printer = PreferencesData.getPrinter();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text('Current Printer ',
                    style: CustomTextStyle.blackMediumSize(18)),
              ),
              _buildInfoRow('Printer', printer.name),
              _buildInfoRow('Connection', printer.connection),
              _buildInfoRow('Address', printer.address),
              _buildInfoRow('Printer Type', printer.type),
              const SizedBox(height: 26),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Pilih Printer',
                  style: CustomTextStyle.blackMediumSize(19),
                ),
              ),
              const SizedBox(height: 8),
              _buildIpInputRow(),
              const SizedBox(height: 24),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final printerListResult =
                          await PrinterTools().getBluetoothDevices();
                      setState(() {
                        printerList = printerListResult;
                      });
                    },
                    child: Container(
                      decoration: CustomContainerStyle.blueButton(),
                      padding:
                          const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: AutoSizeText(
                        'Scan Bluetooth Printers',
                        style: CustomTextStyle.whiteStandard(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  InkWell(
                    onTap: () {
                      BtprintExecutor().testPrint();
                    },
                    child: Container(
                      decoration: CustomContainerStyle.blueButton(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      child: AutoSizeText(
                        'Test bt print',
                        style: CustomTextStyle.whiteStandard(),
                      ),
                    ),
                  ),
                
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  child: _buildBluetoothPrinterList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 2,
          child: Text(title, style: CustomTextStyle.blackMedium()),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(':'),
        ),
        Expanded(
          flex: 5,
          child: Text(value ?? 'Unknown', style: CustomTextStyle.blackMedium()),
        ),
      ],
    );
  }

  Widget _buildIpInputRow() {
    return Row(
      children: [
        Flexible(
          child: TextField(
            inputFormatters: [IPAddressInputFormatter()],
            keyboardType: TextInputType.number,
            controller: tfIpPc,
            decoration: CustomTextfieldStyle.normalHint('IP Address'),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            PreferencesData.setPrinter(PrinterModel(
              name: 'PC PRINTER',
              connection: '3',
              type: 'DOT MATRIX',
              address: tfIpPc.text,
            ));
            setState(() {
              printer = PreferencesData.getPrinter();
            });
          },
          child: Container(
            decoration: CustomContainerStyle.confirmButton(),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Text(
              'Simpan',
              style: CustomTextStyle.whiteStandard(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBluetoothPrinterList() {
    if (printerList.isEmpty) {
      return Center(
        child: Text('Tidak ada perangkat bluetooth, pastikan bluetooth aktif dan scan ulang', style: CustomTextStyle.blackStandard(),),
      );
    }
    return ListView.builder(
      itemCount: printerList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final device = printerList[index];
        return ListTile(
          title: Text(device.name ?? 'Unknown'),
          subtitle: Text(device.address ?? 'No Address'),
          onTap: () {
            setState(() {
              PreferencesData.setPrinter(PrinterModel(
                name: device.name ?? 'Unknown',
                connection: '2',
                type: 'Bluetooth',
                address: device.address ?? '',
              ));
              printer = PreferencesData.getPrinter();
              BtPrint().connectToDevice(device);
            });
            showToastWarning('Printer selected: ${device.name}');
          },
        );
      },
    );
  }
}
