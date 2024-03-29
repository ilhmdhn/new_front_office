import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/base_response.dart';
import 'package:front_office_2/page/bloc/send_approval_bloc.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/event_bus.dart';
import 'package:front_office_2/tools/screen_size.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:lottie/lottie.dart';

class VerificationDialog{
  static Future<bool?> requestVerification(BuildContext ctx, String reception, String note)async{
    Completer<bool?> completer = Completer<bool?>();
    String uniqueTime = DateTime.now().microsecondsSinceEpoch.toString();
    ApprovalCubit approvalCubit = ApprovalCubit();
    approvalCubit.sendApproval(uniqueTime, reception, note);
    showDialog(
      context: ctx, 
      barrierDismissible: false,
      builder: (BuildContext ctxDialog){
        bool isLoading = true;
        bool isConfirmed = false;
        return StatefulBuilder(
          builder: (BuildContext ctxWidget, StateSetter setState){
            eventBus.on<ConfirmationSignalModel>().listen((event) {
              if(uniqueTime == event.code){
                if(ctxWidget.mounted && ctx.mounted && ctxDialog.mounted){
                  if(event.state == true){
                    setState(() {
                      isLoading = false;
                      isConfirmed = true;
                    });
                  }else{
                    setState((){
                      isLoading = false;
                      isConfirmed = false;
                    });
                  }
                }
              }
            });
            return AlertDialog(
              title: 
              isLoading == true?
              Center(child: AutoSizeText('Menunggu Verifikasi Kapten/ Spv', style: CustomTextStyle.titleAlertDialogSize(21), minFontSize: 9,maxLines: 1,)):
              isConfirmed == true?
              Center(child: AutoSizeText('Confirmed', style: CustomTextStyle.titleAlertDialogSize(21), minFontSize: 9,maxLines: 1,)):
              Center(child: AutoSizeText('Ditolak', style: CustomTextStyle.titleAlertDialogSize(21), minFontSize: 9,maxLines: 1,)),
              content: BlocBuilder<ApprovalCubit, BaseResponse>(
                bloc: approvalCubit,
                builder: (ctx, response){
                  return
                  response.isLoading == true?
                  SizedBox(
                    height: ScreenSize.getHeightPercent(ctx, 50),
                    width: ScreenSize.getSizePercent(ctx, 50),
                    child: Center(
                      child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
                    ),
                  ):
                  response.state != true?
                  SizedBox(
                    height: ScreenSize.getHeightPercent(ctx, 50),
                    width: ScreenSize.getSizePercent(ctx, 50),
                    child: Center(
                      child: Text(response.message??'Error request Verification'),
                    ),
                  ):
                  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(ctx).size.width * 0.50,
                      child: AspectRatio(
                        aspectRatio: 1/1,
                        child: isLoading == true?
                        Lottie.asset('assets/animation/waiting_verification.json'):
                        isConfirmed == true?
                        Lottie.asset('assets/animation/confirmed.json'):
                        Lottie.asset('assets/animation/reject.json')
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(ctx).size.width * 0.50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: ElevatedButton(onPressed: (){
                              setState(() {
                                Navigator.pop(ctx, false);
                              });
                            }, 
                            style: CustomButtonStyle.cancel(),
                            child: AutoSizeText('CANCEL', style: CustomTextStyle.whiteStandard(), minFontSize: 9, maxLines: 1,)),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: ElevatedButton(onPressed: (){
                              isLoading == true?
                              {
                                showToastWarning('Belum di konfirmasi')
                              }
                              :isConfirmed?
                              Navigator.pop(ctx, true):
                              Navigator.pop(ctx, false);
                            }, 
                            style: CustomButtonStyle.confirm(),
                            child: AutoSizeText( isLoading == true? 'CHECK': isConfirmed==true? 'CONFIRM':'KEMBALI', style: CustomTextStyle.whiteStandard(), minFontSize: 9, maxLines: 1,)),
                          ),
                        ],
                      ),
                    )
                  ],
                );
                }),
            );
          },
        );
      }).then((value) => completer.complete(value));
      return completer.future;
  }
}