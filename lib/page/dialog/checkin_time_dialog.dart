import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'dart:async';

class CheckinDurationDialog {
  Future<int?> setCheckinTime(BuildContext ctx, String roomCode) async {
    Completer<int?> completer = Completer<int?>();

    showDialog<int>(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              roomCode,
              style: CustomTextStyle.titleAlertDialog(),
            ),
          ),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, 1); // Mengembalikan nilai 1
                        },
                        style: CustomButtonStyle.cancel(),
                        child: Text('First Buttons'),
                      ),
                    ),
                    SizedBox(width: 16), // Spasi antara tombol
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, 2); // Mengembalikan nilai 2
                        },
                        child: Text('Second btn'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      completer.complete(value); // Menyelesaikan future dengan nilai yang diterima dari dialog
    });
    return completer.future; // Mengembalikan future untuk mendapatkan nilai int dari dialog
  }
}
