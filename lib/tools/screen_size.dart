import 'package:flutter/material.dart';

class ScreenSize{
  static double getSizePercent(BuildContext ctx, double size){
    return MediaQuery.of(ctx).size.width * (size/100);
  }

  static double getHeightPercent(BuildContext ctx, double size){
    return MediaQuery.of(ctx).size.width * (size/100);
  }
}