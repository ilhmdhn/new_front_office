import 'package:flutter/material.dart';
import 'package:front_office_2/page/add_on/add_on_widget.dart';
import 'package:front_office_2/page/report/invoice/reprint_invoice.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/preferences.dart';

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
      body: 
      // Center(
        // child: Lottie.asset('assets/animation/cooming_soon.json'),
      // ),
      SingleChildScrollView(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            // AddOnWidget.listButtonNavigation(context, CashDetailPage.nameRoute, 'assets/icon/money.png', 'Rincian Pecahan'),
            // const SizedBox(height: 9,),
            PreferencesData.getUser().level == 'KASIR' || PreferencesData.getUser().level == 'IT' || PreferencesData.getUser().level == 'ACCOUNTING'?
            AddOnWidget.listButtonNavigation(context, ReprintInvoicePage.nameRoute, 'assets/icon/invoice.png', 'Cetak Invoice'): const SizedBox()
            /*SizedBox(
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
            )*/
          ],
        ),
      ),
    );
  }
}