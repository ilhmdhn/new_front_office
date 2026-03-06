import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/page/bloc/int_bloc.dart';
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

    static Future<int> confirmationCancelDo(BuildContext ctx, String itemName, int maxCancel, DetailCheckinModel dataCheckin)async{
      Completer<int> completer = Completer<int>();
      NumberCubit cancelValueBloc = NumberCubit();
      int cancelQty = 1;
      cancelValueBloc.setValue(1);
      showDialog(
        context: ctx, 
        builder: (BuildContext ctxDialog){
          return StatefulBuilder(
            builder: (ctxStfl, setState){
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Center(child: Text('Batalkan pesanan\n$itemName?', style: CustomTextStyle.blackMediumSize(16), textAlign: TextAlign.center)),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: InkWell(
                        child: Image.asset(
                          'assets/icon/minus.png'),
                        onTap: (){
                          if(cancelQty>1){
                            --cancelQty;
                            cancelValueBloc.setValue(cancelQty);
                          }
                      },
                      ),
                      ),
                      const SizedBox(width: 12,),
                      BlocBuilder(
                        bloc: cancelValueBloc,
                        builder: (ctxBloc, value){
                          return Text(value.toString(), style: CustomTextStyle.blackMediumSize(21),);
                        }),
                      const SizedBox(width: 12,),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: InkWell(
                          child: Image.asset('assets/icon/plus.png'),
                        onTap: (){
                          if(cancelQty < maxCancel){
                              ++cancelQty;
                              cancelValueBloc.setValue(cancelQty);
                          }
                      },
                      ),
                      ),
                  ],
                ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pop(ctx, 0);
                      },
                      style: CustomButtonStyle.cancel(),
                      child: AutoSizeText('Cancel', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center,),
                    ),
                  ),
                  const SizedBox(width: 6,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: ()async{
                        final confirmationState = await VerificationDialog.requestVerification(ctx, dataCheckin.reception, dataCheckin.roomCode, 'Cancel order $itemName');
                        
                        if(confirmationState != true){
                          showToastWarning('Cancel order dibatalkan');
                          return;
                        }
                        if(ctx.mounted){
                          Navigator.pop(ctx, cancelQty);
                        }
                      },
                      style: CustomButtonStyle.confirm(),
                      child: AutoSizeText('Konfirmasi', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          );
            }
        );
      }).then((value){
        value ??= 0;
        completer.complete(value);
      });
      return completer.future;
  }

}