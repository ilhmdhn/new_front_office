import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';

class CustomContainerStyle{
  
  static confirmButton(){
    return BoxDecoration(
      color: Colors.green.shade700,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static cancelButton(){
    return BoxDecoration(
      color: Colors.redAccent.shade400,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
          spreadRadius:2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  static blueButton(){
    return BoxDecoration(
      color: CustomColorStyle.appBarBackground(),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
          spreadRadius:2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}