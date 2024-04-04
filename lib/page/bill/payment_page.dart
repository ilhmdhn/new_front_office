import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/list.dart';

class PaymentPage extends StatefulWidget {
  static const nameRoute = '/payment';
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String roomCode = '';
  String paymentMethod = 'CASH';
  bool isLoading = true;
  num nominal = 0;
  @override
  Widget build(BuildContext context) {
    roomCode = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color:  Colors.white,
          ),
          title: Text(roomCode, style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: Column(
          children: [
            const SizedBox(height: 6,),
            Center(child: Text('TOTAL 1.999.999.999', style: CustomTextStyle.blackMediumSize(19))),
            CustomRadioButton(
              defaultSelected: 'CASH',
              buttonLables: paymentMethodList,
              buttonValues: paymentMethodList,
              autoWidth: true,
              elevation: 0,
              radioButtonValue: (value){
                setState(() {
                  paymentMethod = value;
                });
              },
              selectedBorderColor: Colors.transparent,
              unSelectedColor: Colors.white,
              enableShape: true,
              unSelectedBorderColor: CustomColorStyle.appBarBackground(),
              selectedColor: CustomColorStyle.appBarBackground()),

            paymentMethod == 'CASH'?
            TextField(
              decoration: InputDecoration(hintText: 'CASH'),
              onChanged: (value){
                nominal = value as num;
              },
            ):
            paymentMethod == 'CREDIT CARD'?
            TextField(decoration: InputDecoration(hintText: 'CREDIT CARD'),):
            paymentMethod == 'DEBET CARD'?
            TextField(decoration: InputDecoration(hintText: 'DEBET CARD'),):
            paymentMethod == 'E-Money'?
            TextField(decoration: InputDecoration(hintText: 'E-Money'),):
            paymentMethod == 'COMPLIMENTARY'?
            TextField(decoration: InputDecoration(hintText: 'COMPLIMENTARY'),):
            TextField(decoration: InputDecoration(hintText: 'PIUTANG'))
          ],
        ),
      ));
  }
}