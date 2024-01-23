import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonStyle{
  static ButtonStyle blueStandard(){
    return ElevatedButton.styleFrom(
        backgroundColor: CustomColorStyle.BluePrimary(),
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 22,
        ),
        foregroundColor: Colors.white
    );
  }
}