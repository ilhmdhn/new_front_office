import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class SelectPrinterDialog {
  Future<int?> setPrinter(BuildContext ctx, int index) async {
    return showDialog<int>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Select Printer',
              style: CustomTextStyle.titleAlertDialog(),
            ),
          ),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx, 1);
                  },
                  child: Text('Nganu'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
