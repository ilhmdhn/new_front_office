import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front_office_2/data/model/cancel_model.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/toast.dart';

class ConfirmationDialog{
  static Future<bool> confirmation(BuildContext ctx, String title) async {
  if (!ctx.mounted) return false;

  try {
    final result = await showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              title,
              style: CustomTextStyle.blackMediumSize(19),
              textAlign: TextAlign.center,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (ctxDialog.mounted) {
                        Navigator.pop(ctxDialog, false);
                      }
                    },
                    style: CustomButtonStyle.cancelSoft(),
                    child: Text(
                      'Batal',
                      maxLines: 1,
                      style: CustomTextStyle.whiteStandard(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (ctxDialog.mounted) {
                        Navigator.pop(ctxDialog, true);
                      }
                    },
                    style: CustomButtonStyle.confirm(),
                    child: Text(
                      'Konfirmasi',
                      maxLines: 1,
                      style: CustomTextStyle.whiteStandard(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    return result ?? false;
  } catch (e) {
    debugPrint('Dialog error: $e');
    return false;
  }
}

  static Future<CancelModel> confirmationCancelDo(
    BuildContext ctx,
    String itemName,
    int maxCancel,
    DetailCheckinModel dataCheckin,
  ) async {
    int cancelQty = 1;
    TextEditingController tfreason = TextEditingController();
    final result = await showDialog<CancelModel>(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog) {

        return StatefulBuilder(
          builder: (context, setState) {

            return AlertDialog(
              backgroundColor: Colors.white,
              title: Center(
                child: Text(
                  'Batalkan Pesanan\n$itemName?',
                  style: CustomTextStyle.blackMediumSize(16),
                  textAlign: TextAlign.center,
                ),
              ),

              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text('Jumlah dibatalkan:', style: CustomTextStyle.blackSize(14),),
                  ),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// minus
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: InkWell(
                          onTap: () {
                            if (cancelQty > 1) {
                              setState(() {
                                cancelQty--;
                              });
                            }
                          },
                          child: Image.asset('assets/icon/minus.png'),
                        ),
                      ),
                  
                      const SizedBox(width: 12),
                  
                      Text(
                        cancelQty.toString(),
                        style: CustomTextStyle.blackMediumSize(21),
                      ),
                  
                      const SizedBox(width: 12),
                  
                      /// plus
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: InkWell(
                          onTap: () {
                            if (cancelQty < maxCancel) {
                              setState(() {
                                cancelQty++;
                              });
                            }
                          },
                          child: Image.asset('assets/icon/plus.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  TextField(
                    minLines: 3,
                    maxLines: 5,
                    // cursorHeight: 10,
                    decoration: InputDecoration(
                      hintText: 'Alasan void...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(3),
                    ),
                    controller: tfreason,
                  )
                ],
              ),

              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (ctxDialog.mounted) {
                            Navigator.pop(ctxDialog, CancelModel(qty: 0));
                          }
                        },
                        style: CustomButtonStyle.cancel(),
                        child: Text(
                          'Batal',
                          maxLines: 1,
                          style: CustomTextStyle.whiteStandard(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirmationState = await VerificationDialog.requestVerification(
                            ctx,
                            dataCheckin.reception,
                            dataCheckin.roomCode,
                            'Cancel order $itemName',
                          );

                          if (confirmationState.state != true) {
                            showToastWarning('Cancel order dibatalkan');
                            return;
                          }

                          if (ctx.mounted) {
                            Navigator.pop(ctx, CancelModel(qty: cancelQty, reason: tfreason.text, approver: confirmationState.approver));
                          }
                        },
                        style: CustomButtonStyle.confirm(),
                        child: Text(
                          'Konfirmasi',
                          maxLines: 1,
                          style: CustomTextStyle.whiteStandard(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? CancelModel(qty: 0);
  }
}