import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';

class TextFieldDialog{
  Future<String?> inputText(BuildContext ctx){
    String reason = '';
    return(showDialog(
      context: ctx, 
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          title: Center(
            child: Text('Alasan otorisasi', style: CustomTextStyle.blackStandard(),),
          ),
          backgroundColor: CustomColorStyle.white(),
          content: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: CustomTextfieldStyle.normalHint('isi alasan'),
                  onChanged: (value) {
                    reason = value;
                  }
                ),
                const SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: CustomButtonStyle.cancel(),
                      child: Text('CANCEL', style: CustomTextStyle.whiteStandard(),),
                      onPressed: (){
                        Navigator.pop(ctx, null);
                      },
                    ),
                    ElevatedButton(
                        style: CustomButtonStyle.confirm(),
                        child: Text(
                          'CONFIRM',
                          style: CustomTextStyle.whiteStandard(),
                        ),  
                        onPressed: () {
                          Navigator.pop(ctx, reason);
                        },
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      }));
  }
}