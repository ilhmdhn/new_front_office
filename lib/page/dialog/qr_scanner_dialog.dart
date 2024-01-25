import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerDialog extends StatefulWidget {
  const QRScannerDialog({super.key});
  @override
  State<QRScannerDialog> createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<QRScannerDialog> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanSuccess = false;
  String? manualCode;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

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
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: CustomTextfieldStyle.normalHint('Masukkan kode manual'),
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!scanSuccess) {
        scanSuccess = true;
        Navigator.of(context).pop(scanData.code);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
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
