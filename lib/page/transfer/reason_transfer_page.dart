import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';

class TransferReasonPage extends StatefulWidget {
  static const nameRoute = '/transfer-reasong';
  const TransferReasonPage({super.key});

  @override
  State<TransferReasonPage> createState() => _TransferReasonPageState();
}

class _TransferReasonPageState extends State<TransferReasonPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColorStyle.background(),
        appBar: AppBar(
          title: Align(alignment: Alignment.centerLeft ,child: Text('Alasan Transfer Room', style: CustomTextStyle.titleAppBar(),)),
          iconTheme: const IconThemeData(
            color:  Colors.white,
          ),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: Column(
          children: [
            CustomRadioButton(
                    defaultSelected: 1,
                    selectedBorderColor: Colors.transparent,
                    unSelectedBorderColor: CustomColorStyle.appBarBackground(),
                    enableShape: false,
                    horizontal: false,
                    padding: 0,
                    elevation: 0, // Menghilangkan bayangan
                    buttonLables: transferReason, 
                    buttonValues: transferReason,
                    buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: CustomTextStyle.blackMedium()
                    ),
                    autoWidth: true,                        
                    radioButtonValue: (value){
                      setState(() {
                        // dpCode = value;
                        // dpNote = downPaymentList[value-1];
                      });
                    }, 
                    unSelectedColor: Colors.white, 
                    selectedColor: CustomColorStyle.appBarBackground()
                  ),
          ],
        ),
      )
    );
  }
}