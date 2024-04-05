import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';
import 'package:front_office_2/data/model/edc_response.dart';

class PaymentListDialog{
  static Future<String?> eMoneyList(BuildContext ctx, String? choosed) async {
    return showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext ctxDialog){
        return StatefulBuilder(
          builder: (ctxStfl, setState){
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              titlePadding: const EdgeInsets.only(top: 12, bottom: 0),
              backgroundColor: Colors.white,
            title: Center(child: Text('Pilih E-Money', style: CustomTextStyle.titleAlertDialog(),)),
            content: CustomRadioButton(
              defaultSelected: choosed,
              buttonLables: eMoneyValueList,
              buttonValues: eMoneyValueList, 
              autoWidth: true,
              elevation: 0,
              horizontal: true,
              radioButtonValue: (value){
                setState((){
                  choosed = value;
                });    
              },
              selectedBorderColor: Colors.transparent,
              enableShape: true,
              unSelectedBorderColor: CustomColorStyle.appBarBackground(),
              unSelectedColor: Colors.white,
              selectedColor: CustomColorStyle.appBarBackground()
            ),
            actions: [
              InkWell(
                onTap: (){
                  Navigator.pop(ctxDialog);
                },
                child: Container(
                  decoration: CustomContainerStyle.cancelButton(),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('CANCEL', style: CustomTextStyle.whiteStandard(),),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(ctxDialog, choosed);
                },
                child: Container(
                  decoration: CustomContainerStyle.confirmButton(),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('CONFIRM', style: CustomTextStyle.whiteStandard(),),
                ),
              ),
            ],
            );
          },
        );
      }
    );
  }

  static Future<String?> piutangList(BuildContext ctx, String? choosed) async {
    return showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext ctxDialog){
        return StatefulBuilder(
          builder: (ctxStfl, setState){
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              titlePadding: const EdgeInsets.only(top: 12, bottom: 0),
              backgroundColor: Colors.white,
            title: Center(child: Text('Piutang', style: CustomTextStyle.titleAlertDialog(),)),
            content: CustomRadioButton(
              defaultSelected: choosed,
              buttonLables: piutangValueList,
              buttonValues: piutangValueList, 
              autoWidth: true,
              elevation: 0,
              horizontal: true,
              radioButtonValue: (value){
                setState((){
                  choosed = value;
                });    
              },
              selectedBorderColor: Colors.transparent,
              enableShape: true,
              unSelectedBorderColor: CustomColorStyle.appBarBackground(),
              unSelectedColor: Colors.white,
              selectedColor: CustomColorStyle.appBarBackground()
            ),
            actions: [
              InkWell(
                onTap: (){
                  Navigator.pop(ctxDialog);
                },
                child: Container(
                  decoration: CustomContainerStyle.cancelButton(),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('CANCEL', style: CustomTextStyle.whiteStandard(),),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(ctxDialog, choosed);
                },
                child: Container(
                  decoration: CustomContainerStyle.confirmButton(),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text('CONFIRM', style: CustomTextStyle.whiteStandard(),),
                ),
              ),
            ],
            );
          },
        );
      }
    );
  }

  static Future<EdcDataModel?> selectEdc(BuildContext ctx)async{
    return showDialog(
      context: ctx, 
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          title: Text('Pilih Edc', style: CustomTextStyle.titleAlertDialog(),),
        );
      });
  }
}