import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/tools/list.dart';


class SelectPrinterDialog {
  Future<String?> setPrinter(BuildContext ctx, String? chooseIndex) async {
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Select Printer',
              style: CustomTextStyle.titleAlertDialogSize(23),
            ),
          ),
          backgroundColor: CustomColorStyle.white(),
          content: SizedBox(
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
                      buttonLables: printerSizeList, 
                      buttonValues: printerSizeList,
                        buttonTextStyle: ButtonTextStyle(
                        selectedColor: Colors.white,
                        unSelectedColor: Colors.black,
                        textStyle: CustomTextStyle.blackStandard()),
                      autoWidth: true,                        
                      radioButtonValue: (value){
                        chooseIndex = value;
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
                      )),
                    ElevatedButton(
                      style: CustomButtonStyle.confirm(),
                      onPressed: (){
                        Navigator.pop(context, chooseIndex);
                      }, 
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        child: Text('Ganti', style: CustomTextStyle.whiteSize(19)),
                      ))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
