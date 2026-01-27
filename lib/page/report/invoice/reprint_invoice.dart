import 'package:flutter/material.dart';
import 'package:front_office_2/page/dialog/verification_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/printer/print_executor.dart';
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
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: CustomColorStyle.appBarBackground(),
          title: Text(
            'Cetak Invoice',
            style: CustomTextStyle.titleAppBar(),
          ),
        ),
        backgroundColor: CustomColorStyle.background(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: tfRcp,
                      decoration:
                          CustomTextfieldStyle.normalHint('Masukkan Kode RCP'),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        //fix before compile
                        final reprintBillState = await VerificationDialog.requestVerification(context,(tfRcp.text), 'No Room', 'Cetak ulang invoice ${tfRcp.text}');
                        // final reprintBillState = true;
                        if (reprintBillState != true) {
                          showToastWarning('Permintaan dibatalkan');
                          return;
                        }
                        // showToastWarning(tfRcp.text);
                        PrintExecutor.printInvoice(tfRcp.text);
                        // DoPrint.printInvoice(tfRcp.text);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: CustomContainerStyle.blueButton(),
                        child: Center(
                            child: Text(
                          'Print',
                          style: CustomTextStyle.whiteSize(19),
                        )),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
