import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerDialog extends StatefulWidget {
  const QRScannerDialog({super.key});
  @override
  State<QRScannerDialog> createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<QRScannerDialog> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController controller = MobileScannerController();
  bool scanSuccess = false;
  String? manualCode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Scan QR Code', style: CustomTextStyle.titleAlertDialog(), textAlign: TextAlign.center,),
      content: SizedBox(
        width: MediaQuery.of(context).size.width*0.7,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AspectRatio(
                aspectRatio: 1/1,
                child: MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (!scanSuccess && barcode.rawValue != null) {
                        scanSuccess = true;
                        Navigator.of(context).pop(barcode.rawValue);
                        break;
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: CustomTextfieldStyle.normalHint('Masukkan kode'),
                      onChanged: (value) => manualCode = value,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    style: CustomButtonStyle.blueStandard(),
                    onPressed: (){
                    Navigator.pop(context, manualCode);
                  }, child: Text('Submit', style: CustomTextStyle.whiteStandard(),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Future<String?> showQRScannerDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return const QRScannerDialog();
    },
  );
}
