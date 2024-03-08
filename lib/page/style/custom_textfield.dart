import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static InputDecoration normalHint(hint){
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.black87, width: 1.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6)
    );
  }
  
  static InputDecoration normalHintBlue(hint){
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 12),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: CustomColorStyle.appBarBackground(), width: 1.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6)
    );
  }

}