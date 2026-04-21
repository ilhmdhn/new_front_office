import 'package:flutter/material.dart';

extension ScreenExt on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  bool get isTablet => width > 600;
  bool get isDesktop => width > 900;

  // persen versi enak 😄
  double wp(num percent) => width * (percent / 100);
  double hp(num percent) => height * (percent / 100);
}