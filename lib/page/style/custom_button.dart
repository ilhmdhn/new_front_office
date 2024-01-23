import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonStyle{
  static ButtonStyle blueStandard(){
    return ElevatedButton.styleFrom(
        backgroundColor: CustomColorStyle.BluePrimary(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 19,
        ),
        foregroundColor: Colors.white
    );
  }

  static ButtonStyle cancel(){
    return ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 17,
        ),
        foregroundColor: Colors.white
    );
  }

  static ButtonStyle confirm(){
    return ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 17,
        ),
        foregroundColor: Colors.white
    );
  }
}