import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';

class CustomTextfieldStyle{
  static InputDecoration characterNormal(){
    return InputDecoration(
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
    );
  }
}