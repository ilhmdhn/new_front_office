import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/detail_room_checkin_response.dart';
import 'package:front_office_2/page/bloc/int_bloc.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/toast.dart';

class ConfirmationDialog{
/*
  static Future<bool> confirmation(BuildContext ctx, String title)async{
    Completer<bool> completer = Completer<bool>();

    final isPotrait = isVertical(ctx);

    showDialog(
      context: ctx,
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(child: isPotrait?
            AutoSizeText(title, style: CustomTextStyle.blackMediumSize(19), maxLines: 1, minFontSize: 12,):
            Text(title, style: CustomTextStyle.blackMediumSize(19), maxLines: 1,)
          ),
          content: const SizedBox(height: 0),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(ctx, false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: CustomContainerStyle.cancelButton(),
                      child: AutoSizeText('Cancel', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center,),
                    ),
                  ),
                ),
                const SizedBox(width: 6,),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(ctx, true);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: CustomContainerStyle.confirmButton(),
                      child: AutoSizeText('Konfirmasi', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }).then((value){
        value ??= false;
        completer.complete(value);
      });
      return completer.future;
  }
*/
  static Future<bool> confirmation(BuildContext ctx, String title) async {
    if (!ctx.mounted) return false;
  
    try {
      final result = await showDialog<bool>(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext ctxDialog) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: AutoSizeText(title, style: CustomTextStyle.blackMediumSize(19), maxLines: 1, minFontSize: 12,),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (ctxDialog.mounted) {
                          Navigator.pop(ctx, false);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: AutoSizeText('Cancel', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center,),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (ctxDialog.mounted) {
                          Navigator.pop(ctx, true);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: AutoSizeText('Konfirmasi', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center),
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
                title: Center(child: AutoSizeText('Batalkan pesanan\n$itemName?', style: CustomTextStyle.blackMediumSize(16), maxLines: 3, minFontSize: 12, textAlign: TextAlign.center,)),
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
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(ctx, 0);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: CustomContainerStyle.cancelButton(),
                        child: AutoSizeText('Cancel', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6,),
                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        final confirmationState = await VerificationDialog.requestVerification(ctx, dataCheckin.reception, dataCheckin.roomCode, 'Cancel order $itemName');
                        
                        if(confirmationState != true){
                          showToastWarning('Cancel order dibatalkan');
                          return;
                        }
                        if(ctx.mounted){
                          Navigator.pop(ctx, cancelQty);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: CustomContainerStyle.confirmButton(),
                        child: AutoSizeText('Konfirmasi', maxLines: 1, minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center),
                      ),
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