import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:lottie/lottie.dart';

class VerificationDialog{
  static Future<bool?> requestVerification(BuildContext ctx, String verificationCode)async{
    Completer<bool?> completer = Completer<bool?>();
    showDialog(
      context: ctx, 
      barrierDismissible: false,
      builder: (BuildContext ctxDialog){
        bool isConfirmed = false;
        return StatefulBuilder(
          builder: (BuildContext ctxWidget, StateSetter setState){
            return AlertDialog(
              title: 
              isConfirmed == false?
              Center(child: AutoSizeText('Menunggu Verifikasi Kapten/ Spv', style: CustomTextStyle.titleAlertDialog(), minFontSize: 9,maxLines: 1,)):
              Center(child: AutoSizeText('Confirmed', style: CustomTextStyle.titleAlertDialog(), minFontSize: 9,maxLines: 1,)),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(ctx).size.width * 0.50,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: 
                      isConfirmed == false?
                      Lottie.asset('assets/animation/waiting_verification.json'):
                      Lottie.asset('assets/animation/confirmed.json')
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
                            setState(() {
                              isConfirmed = !isConfirmed;
                            });
                          }, 
                          style: CustomButtonStyle.confirm(),
                          child: AutoSizeText('CONFIRM', style: CustomTextStyle.whiteStandard(), minFontSize: 9, maxLines: 1,)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }).then((value) => completer.complete(value));
      return completer.future;
  }
}