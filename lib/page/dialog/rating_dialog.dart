import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:front_office_2/data/request/cloud_request.dart';
import 'package:front_office_2/page/main_page.dart';
import 'package:front_office_2/page/style/custom_container.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/page/style/custom_textfield.dart';
import 'package:front_office_2/tools/di.dart';
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

  static void submitRate(BuildContext ctx, String invoice, String memberCode, String memberName)async{
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext ctxDialog){
        double rate = 3;
        String hint = '';
        bool isOk = false;
        TextEditingController reasonController = TextEditingController();
        return StatefulBuilder(
          builder: (BuildContext ctxStateful, setState){
            if(rate < 1.5){
              hint = 'Sampaikan keluhan kamu';
            }else{
              hint = 'Tulis pendapat kamu mengenai pelayanan kami';
            }
            
            if(isOk == true){
              Future.delayed(const Duration(seconds: 3), () {
              // if(ctx.mounted){
                
              // }else{
                // navigatorKey.
                getIt<NavigationService>().pushNamedAndRemoveUntil(MainPage.nameRoute);
                // Navigator.pop(ctx);
              // }
              });

              return SizedBox(
                child: LottieBuilder.asset('assets/animation/done.json'),
              );
            }
            
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Center(child: AutoSizeText('Berikan rating kami', style: CustomTextStyle.titleAlertDialogSize(21), maxLines: 1, minFontSize: 10,)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RatingBar.builder(
                    initialRating: 3,
                    minRating: 0.5,
                    itemSize: 35,
                    wrapAlignment: WrapAlignment.center,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState((){
                        rate = rating;
                      });
                    },
                    ),
                    const SizedBox(height: 12,),
                    TextField(
                      maxLines: 5,
                      minLines: 2,
                      controller: reasonController,
                      keyboardType: TextInputType.multiline,
                      decoration: CustomTextfieldStyle.normalHint(hint),
                    ),
                        const SizedBox(height: 12,),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 6,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(ctx, false);
                            },
                            child: Container(
                              decoration: CustomContainerStyle.cancelButton(),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              child: Center(child: Text('CANCEL', style: CustomTextStyle.whiteSize(16),)),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: SizedBox()
                        ),
                        Expanded(
                          flex: 6,
                          child: InkWell(
                            onTap: ()async{
                              await CloudRequest.insertRate(invoice, memberCode, rate, reasonController.text);
                              setState((){
                                isOk = true;
                              });
                            },
                            child: Container(
                              decoration: CustomContainerStyle.confirmButton(),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              child: Center(child: Text('SUBMIT', style: CustomTextStyle.whiteSize(16),)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ); 
          });
        }
    );
  }
}