import 'package:flutter/material.dart';

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
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6)
    );
  }
}