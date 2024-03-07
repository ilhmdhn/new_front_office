import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/dialog/qr_scanner_dialog.dart';
import 'package:front_office_2/page/style/custom_button.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/tools/toast.dart';

class EditCheckinPage extends StatelessWidget {
  static const nameRoute = '/edit-checkin';
  EditCheckinPage({super.key});

  int pax = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Room Checkin', style: CustomTextStyle.titleAppBar(),),
          backgroundColor: CustomColorStyle.appBarBackground(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: AutoSizeText('INFORMASI CHECKIN', style: CustomTextStyle.blackMediumSize(21), minFontSize: 12, maxLines: 1,),
                ),
                const SizedBox(height: 12,),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('ILHAM DOHAAN', style: CustomTextStyle.blackStandard(),),
                          Text('000022061122', style: CustomTextStyle.blackStandard(),),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 39,color: CustomColorStyle.bluePrimary(),),
                    Expanded(
                      child: Column(
                        children: [
                          Text('PR A Xiantiande', style: CustomTextStyle.blackStandard(),),
                          Text('Sisa 9 Jam 54 Menit', style: CustomTextStyle.blackStandard(),),
                      ],))
                  ],
                ),
                const SizedBox(height: 12,),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText('Jumlah Pengunjung', style: CustomTextStyle.blackMediumSize(15), maxLines: 1, minFontSize: 12,),
                    const SizedBox(width: 12,),
                    InkWell(
                                onTap: (){
                                  setState((){
                                    if(pax>1){
                                      --pax;
                                    }
                                  });
                                },
                                child: SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: Image.asset(
                                    'assets/icon/minus.png'),
                                )
                              ),
                              const SizedBox(width: 12,),
                              Text(pax.toString(), style: CustomTextStyle.blackMediumSize(21),),
                              const SizedBox(width: 12,),
                              InkWell(
                                onTap: (){
                                  setState((){
                                      ++pax;
                                  });
                                },
                                child: SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: Image.asset(
                                    'assets/icon/plus.png'),
                                )
                              ),
                  ],
                ),
                */Row(
                  children: [
                    ElevatedButton(
                      onPressed: ()async{
                        final qrCode = await showQRScannerDialog(context);
                        if(qrCode != null){
                          showToastWarning(qrCode.toString());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text('Voucher', style: CustomTextStyle.whiteStandard(),),
                      ),
                      style: CustomButtonStyle.blueAppbar()),
                  ],
                )
              ],
            ),
          ),
        ),
      ));
  }
}