import 'package:flutter/material.dart';
class CustomColorStyle{
  static Color background(){
    return CustomColorStyle().hexToColor('#F6F8FA');
  }

  static Color secondaryBackground(){
    return Colors.white;
  }

  static Color appBarBackground() {
    return CustomColorStyle().hexToColor('#2296F3');
  }

  static Color bluePrimary(){
    return CustomColorStyle().hexToColor('#0066FF');
  }

  static Color white(){
    return CustomColorStyle().hexToColor('#FFFFFFFF');
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}