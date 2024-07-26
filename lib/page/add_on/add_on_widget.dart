import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:lottie/lottie.dart';

class AddOnWidget{

  static Widget loading(){
    return Center(
      child: CircularProgressIndicator(
        color: CustomColorStyle.appBarBackground(),
      ),
    );
  }

  static Widget error(String? error){
    return Center(
      child: AutoSizeText(
        error??'Error get data', style: CustomTextStyle.blackStandard(), maxLines: 5,
      ),
    );
  }

  static Widget empty(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/animation/empty.json', height: 226, width: 226,),
          const SizedBox(height: 12,),
          Text('Empty', style: CustomTextStyle.blackMedium(),),
        ],
      ),
    );
  }

  static Widget listButtonNavigation(BuildContext ctx, String destination, String assets, String name){
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal:  8.0),
                child: InkWell(
                  onTap: ()async{
                    Navigator.pushNamed(ctx, destination);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 36,
                            child: Image.asset(assets)
                          ),
                        Expanded(
                          // width: widthTextButton,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            child: AutoSizeText(name, style: CustomTextStyle.blackMediumSize(19),  minFontSize: 14, wrapWords: false,maxLines: 2),
                          )),
                        const SizedBox(
                          width: 26,
                          child: Icon(Icons.arrow_forward_ios, color: Colors.green,)),
                      ],
                    ),
                  ), 
                  ),
              );
  }
}