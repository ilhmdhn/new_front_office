import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/execute_printer.dart';
import 'package:front_office_2/tools/toast.dart';

class ReprintInvoicePage extends StatefulWidget {
  static const nameRoute = '/reprint-invoice';
  const ReprintInvoicePage({super.key});

  @override
  State<ReprintInvoicePage> createState() => _ReprintInvoicePageState();
}

class _ReprintInvoicePageState extends State<ReprintInvoicePage> {
  TextEditingController tfRcp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
      iconTheme: const IconThemeData(
      color: Colors.white, 
      ),
        backgroundColor: CustomColorStyle.appBarBackground(),
        title: Text('Cetak Invoice', style: CustomTextStyle.titleAppBar(),),
      ),
      backgroundColor: CustomColorStyle.background(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 24,),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: tfRcp,
                    decoration: CustomTextfieldStyle.normalHint('Masukkan Kode RCP'),
                  ),
                ),
                const SizedBox(width: 12,),
                Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      showToastWarning(tfRcp.text);
                      DoPrint.printInvoice(tfRcp.text);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: CustomContainerStyle.blueButton(),
                      child: Center(child: Text('Print', style: CustomTextStyle.whiteSize(19),)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    ));
  }
}