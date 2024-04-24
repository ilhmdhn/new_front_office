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
}