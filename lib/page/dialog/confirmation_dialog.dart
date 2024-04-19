import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/screen_size.dart';

class ConfirmationDialog{
  static Future<bool> confirmation(BuildContext ctx, String title)async{
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: ctx, 
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(child: AutoSizeText(title, style: CustomTextStyle.blackMediumSize(19), maxLines: 1, minFontSize: 12,)),
          actions: [
            SizedBox(
              width: ScreenSize.getSizePercent(ctx, 75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(ctx, false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: CustomContainerStyle.cancelButton(),
                        child: AutoSizeText('Cancel', minFontSize: 9, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center,),
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
                        child: AutoSizeText('Konfirmasi', minFontSize: 1, style: CustomTextStyle.whiteStandard(), textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }).then((value){
        value ??= false;
        completer.complete(value);
      });
      return completer.future;
  }
}