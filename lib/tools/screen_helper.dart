import 'package:flutter/widgets.dart';

class ScreenHelper {
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isTablet(BuildContext context) {
    return width(context) > 600;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) > 900;
  }
}