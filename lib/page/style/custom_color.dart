import 'package:flutter/material.dart';
class CustomColorStyle{
  static Color background(){
    return CustomColorStyle().hexToColor('#edf2fb');
  }

  static Color appBarBackground() {
    return CustomColorStyle().hexToColor('#2296F3');
  }

  static Color bluePrimary(){
    return CustomColorStyle().hexToColor('#0066FF');
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}