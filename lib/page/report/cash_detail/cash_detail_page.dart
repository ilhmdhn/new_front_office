import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:front_office_2/tools/toast.dart';
import 'package:intl/intl.dart';
class CashDetailPage extends StatefulWidget {
  static const nameRoute = '/cash-detail';
  const CashDetailPage({super.key});

  @override
  State<CashDetailPage> createState() => _CashDetailPageState();
}

class _CashDetailPageState extends State<CashDetailPage> {

  DateTime firstDate = DateTime.now().subtract(const Duration(days: 7));
  String pickDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color:  Colors.white, //change your color here
          ),
          backgroundColor: CustomColorStyle.appBarBackground(),
          title: Text('Pecahan Rupiah', style: CustomTextStyle.titleAppBar(),),
        ),
        backgroundColor: CustomColorStyle.background(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 72,
                    child: AutoSizeText('Tanggal: ', style: CustomTextStyle.blackMedium(),)),
                  Text(pickDate, style: CustomTextStyle.blackMedium(),),
                  InkWell(
                    onTap: ()async{
                      final date = await showCalendarDatePicker2Dialog(
                        context: context,
                        dialogSize: const Size(325, 400),
                        dialogBackgroundColor: CustomColorStyle.white(),
                        config: CalendarDatePicker2WithActionButtonsConfig(
                          firstDate: firstDate,
                          selectedDayHighlightColor: CustomColorStyle.bluePrimary(),
                          daySplashColor: Colors.lightBlue,
                          lastDate: DateTime.now(),
                          calendarType: CalendarDatePicker2Type.single,
                        ),
                        value: [DateTime.now()]
                      );
                      if(date != null){
                        setState(() {
                          pickDate = DateFormat('dd/MM/yyyy').format(date[0]!);
                        });
                      }
                    },
                    child: Icon(Icons.edit, color: Colors.grey.shade600,),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: AutoSizeText('Shift:', style: CustomTextStyle.blackMedium(),)),
                  CustomRadioButton(
                    buttonLables: const ['1', '2'], 
                    buttonValues: const [1, 2],
                    enableButtonWrap: true,
                    enableShape: true,
                    unSelectedBorderColor: Colors.grey,
                    height: 21,
                    width: 61,
                    padding: 0,
                    radioButtonValue: (value){
                      showToastWarning(value.toString());
                    }, 
                    unSelectedColor: Colors.white, 
                    selectedColor: CustomColorStyle.bluePrimary()
                  )
                ],
              ),
              const SizedBox(height: 10,),
              AutoSizeText('Pecahan Tunai', style: CustomTextStyle.titleAlertDialog(),),
              const Row(
                children: [
                  Text('Selisih')
                ],
              ),
              const SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ));
  }
}