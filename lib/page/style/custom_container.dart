import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';

class CustomContainerStyle{
  
  static Decoration confirmButton(){
    return BoxDecoration(
      color: Colors.green.shade700,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha:  0.6),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static Decoration cancelButton(){
    return BoxDecoration(
      color: Colors.redAccent.shade400,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha:  0.6),
          spreadRadius:2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static Decoration blueButton(){
    return BoxDecoration(
      color: CustomColorStyle.appBarBackground(),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha:  0.6),
          spreadRadius:2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static Decoration whiteList(){
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    );
  }

  static Decoration cancelList(){
    return BoxDecoration(
      color: Colors.pink,
      borderRadius: BorderRadius.circular(10),
    );
  }

  static Decoration barInactive(){
    return BoxDecoration(
      color: Colors.grey.shade300,
      // borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha:  0.6),
          spreadRadius:1,
          // blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
  static Decoration barActive(){
    return BoxDecoration(
      color: CustomColorStyle.appBarBackground(),
      // borderRadius: BorderRadius.circular(10),
      // boxShadow: [
        // BoxShadow(
          // color: Colors.grey.withValues(alpha:  0.6),
          // spreadRadius:2,
          // blurRadius: 7,
          // offset: const Offset(0, 3),
        // ),
      // ],
    );
  }
}