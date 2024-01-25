import 'package:flutter/material.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/setting/printer/printer_page.dart';
// import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/helper.dart';
import 'package:front_office_2/tools/toast.dart';

class OperationalPage extends StatefulWidget {
  static const nameRoute = '/operational';
  const OperationalPage({super.key});

  @override
  State<OperationalPage> createState() => _OperationalPageState();
}

class _OperationalPageState extends State<OperationalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColorStyle.appBarBackground(),
        foregroundColor: Colors.white,
        title: Text('Operasional', style: CustomTextStyle.titleAppBar(),selectionColor: Colors.white,),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications))
        ],
      ),
      backgroundColor: CustomColorStyle.background(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 55,
                  child: CircleAvatar(
                    backgroundImage: Image.asset('assets/icon/user.png').image,
                  ),
                ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('USER', style: CustomTextStyle.blackMedium()),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black,
                  ),
                  Text('ACCOUNTING', style: CustomTextStyle.blackMedium()),
                ],
              ),
            )
              ],
            ),
            const SizedBox(height: 19,),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(children: [
                    InkWell(
                      onTap: ()async{
                        String? result = await showQRScannerDialog(context);
                        if(isNotNullOrEmpty(result)){
                          showToastWarning(result.toString());
                        }
                      },
                      child: Container(
                        color: Colors.green,
                        child: const Text('CHECKIN'),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, PrinterPage.nameRoute);
                      },
                      child: Container(
                        color: Colors.green,
                        child: const Text('PRINTER'),
                      ),
                    )
                  
                  ],),
                ]),
            )
            ],
        ),
      ),
    );
  }
}