import 'package:flutter/material.dart';
import 'package:front_office_2/page/report/sales/sales_report_page.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';

class ReportPage extends StatefulWidget {
    static const nameRoute = '/report';
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        title: Text('Laporan', style: CustomTextStyle.titleAppBar(),),
      ),
      backgroundColor: CustomColorStyle.background(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){},
                style: CustomButtonStyle.blueWidth(),
                child: Text('Status Kas Masuk', style: CustomTextStyle.whiteSize(19),)),
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, MySalesPage.nameRoute);
                },
                style: CustomButtonStyle.blueWidth(),
                child: Text('My Sales', style: CustomTextStyle.whiteSize(19),)),
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){},
                style: CustomButtonStyle.blueWidth(),
                child: Text('Cancel Order', style: CustomTextStyle.whiteSize(19),)),
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){},
                style: CustomButtonStyle.blueWidth(),
                child: Text('Ringkasan Penjualan Harian', style: CustomTextStyle.whiteSize(19),)),
            )
          ],
        ),
      ),
    );
  }
}