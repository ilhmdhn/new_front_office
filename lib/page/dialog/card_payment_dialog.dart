import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_office_2/data/model/edc_response.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/bloc/edc_bloc.dart';
import 'package:front_office_2/tools/list.dart';
import 'package:front_office_2/tools/screen_size.dart';

class CardPaymentDialog{
  Future<String?> edcMachine(BuildContext ctx){
    String? chooseEdc;
    EdcCubit edcResponse = EdcCubit();
    edcResponse.getEdc();
    return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Center(
            child: Text('Pilih Mesin Edc', style: CustomTextStyle.titleAlertDialog(),),
          ),
          backgroundColor: CustomColorStyle.white(),
          content: BlocBuilder(
            bloc: edcResponse,
            builder: (BuildContext ctxBloc, EdcResponse edc){
              List<String> edcList = [];
              for (var element in edc.data) {
                edcList.add(element.edcName.toString());
              }
              return
              edc.isLoading == true?
              SizedBox(
                width: ScreenSize.getSizePercent(ctx, 50),
                height: ScreenSize.getHeightPercent(ctx, 50),
                child: Center(
                  child: CircularProgressIndicator(color: CustomColorStyle.appBarBackground(),),
                ),
              ):
              edc.state != true?
              SizedBox(
                width: ScreenSize.getSizePercent(ctx, 70),
                height: ScreenSize.getHeightPercent(ctx, 50),
                child: Center(
                  child: Text(edc.message.toString()),
                ),
              ):
              PopScope(
                canPop: false,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomRadioButton(
                          // defaultSelected: chooseIndex,
                          selectedBorderColor: Colors.transparent,
                          unSelectedBorderColor: CustomColorStyle.appBarBackground(),
                          enableShape: true,
                          horizontal: true,
                          elevation: 0, // Menghilangkan bayangan
                          buttonLables: edcList,
                          buttonValues: edcList,
                            buttonTextStyle: ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: CustomTextStyle.blackStandard()),
                          autoWidth: true,                        
                          radioButtonValue: (value){
                            chooseEdc = value;
                          }, 
                          unSelectedColor: Colors.white,
                          selectedColor: CustomColorStyle.appBarBackground()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: CustomButtonStyle.cancel(),
                            onPressed: (){
                              Navigator.pop(context);
                            }, 
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 19),
                              child: Text('Batal', style: CustomTextStyle.whiteSize(19)),
                            )
                          ),
                          ElevatedButton(
                            style: CustomButtonStyle.confirm(),
                            onPressed: (){
                              Navigator.pop(context, chooseEdc);
                            }, 
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 19),
                              child: Text('Ganti', style: CustomTextStyle.whiteSize(19)),
                            )
                          )
                      ],
                    )
                  ],
                ),
                            ),
              );
            }
          ),
        );
      });
  }

  Future<String?> cardType(BuildContext ctx){
    String? chooseCardType;
    return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Center(
            child: Text('Pilih Tipe Kartu', style: CustomTextStyle.titleAlertDialog(),),
          ),
          backgroundColor: CustomColorStyle.white(),
          content: 
              PopScope(
                canPop: false,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomRadioButton(
                          // defaultSelected: chooseIndex,
                          selectedBorderColor: Colors.transparent,
                          unSelectedBorderColor: CustomColorStyle.appBarBackground(),
                          enableShape: true,
                          horizontal: true,
                          elevation: 0, // Menghilangkan bayangan
                          buttonLables: cardTypeList,
                          buttonValues: cardTypeList,
                            buttonTextStyle: ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: CustomTextStyle.blackStandard()),
                          autoWidth: true,                        
                          radioButtonValue: (value){
                            chooseCardType = value;
                          }, 
                          unSelectedColor: Colors.white,
                          selectedColor: CustomColorStyle.appBarBackground()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: CustomButtonStyle.cancel(),
                            onPressed: (){
                              Navigator.pop(context);
                            }, 
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 19),
                              child: Text('Batal', style: CustomTextStyle.whiteSize(19)),
                            )
                          ),
                          ElevatedButton(
                            style: CustomButtonStyle.confirm(),
                            onPressed: (){
                              Navigator.pop(context, chooseCardType);
                            }, 
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 19),
                              child: Text('Ganti', style: CustomTextStyle.whiteSize(19)),
                            )
                          )
                      ],
                    )
                  ],
                ),
                ),
              ),
          );
      });
  }
}