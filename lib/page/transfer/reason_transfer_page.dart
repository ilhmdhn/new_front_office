import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText("Alasan Transfer", style: CustomTextStyle.blackStandard(),),
              Row(
                children: [
                  Flexible(
                    child: CustomRadioButton(
                      defaultSelected: "Overpax",
                      selectedBorderColor: Colors.transparent,
                      unSelectedBorderColor: CustomColorStyle.appBarBackground(),
                      enableShape: true,
                      shapeRadius: 0,
                      spacing: 0,
                      absoluteZeroSpacing: true,
                      margin: const EdgeInsets.only(top: 6),
                      horizontal: true,
                      // absoluteZeroSpacing: true,
                      // wrapAlignment: WrapAlignment.center,
                      elevation: 0, // Menghilangkan bayangan
                      buttonLables: transferReason, 
                      buttonValues: transferReason,
                      buttonTextStyle: ButtonTextStyle(
                        selectedColor: Colors.white,
                        unSelectedColor: Colors.black,
                        textStyle: CustomTextStyle.blackMedium()
                      ),
                      autoWidth: true,
                      enableButtonWrap: true,  
                      padding: 0,                      
                      radioButtonValue: (value){
                      setState(() {
                    
                      });
                      }, 
                      unSelectedColor: Colors.white, 
                      selectedColor: CustomColorStyle.appBarBackground()
                    ),
                  ),
                  const Flexible(child: SizedBox())
                ],
              ),
              Center(
                child: Text("Room Type", style: CustomTextStyle.blackStandard(),),
              ),
              
            ],
          ),
        ),
      )
    );
  }
}