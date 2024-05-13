import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class RatingDialog{
  
  static Future<void> viewQr(BuildContext ctx ,String invoice)async{
    showDialog(
      context: ctx, 
      builder: (BuildContext ctxDialog){
        const qrDecoration = PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(
          color: Colors.black,
          ),
          image: PrettyQrDecorationImage(
            image: AssetImage('assets/icon/new_logo.png'),
            position: PrettyQrDecorationImagePosition.embedded,
          ),
        );

        final qrCode = QrCode.fromData(
          data: 'https://happypuppy.id/',
          errorCorrectLevel: QrErrorCorrectLevel.H,
        );

        final qrImage = QrImage(qrCode);

        return AlertDialog(
          contentPadding: const EdgeInsets.only(bottom: 0, left: 24, right: 24, top: 12),
          backgroundColor: Colors.white,
          title: Center(
            child: Text('Berikan rating kami', style: CustomTextStyle.titleAlertDialogSize(21),),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1/1,
                child: PrettyQrView(
                  qrImage: qrImage,
                  decoration: qrDecoration
                ),
              ),
              SizedBox(
                height: 50,
                child: Stack(
                  children: [
                    Positioned(
                      top: -100,
                      bottom: -100,
                      left: 0,
                      right: 0,
                      child: AspectRatio(
                        aspectRatio: 1/1,
                          child: Lottie.asset('assets/animation/star.json', width: double.infinity),
                        ),
                    ),
                  ],
                ),
                ),
                // const SizedBox(height: 6,),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Container(
                //     decoration: CustomContainerStyle.confirmButton(),
                //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //     child: Text('Done', style: CustomTextStyle.whiteSize(19)),
                //   ),
                // ),
                const SizedBox(height: 12),
            ],
          ),
        );
      });
  }

  static void submitRate(BuildContext ctx, String invoice)async{
    
  }
}