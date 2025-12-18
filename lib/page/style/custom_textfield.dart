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
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
    );
  }

  static InputDecoration normalHint(String hint){
    return InputDecoration(
      hintText: hint,
      counterText: "",
      hintStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.grey,
        fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.black87, width: 1.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6)
    );
  }
  
  static InputDecoration normalHintBlue(String hint){
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