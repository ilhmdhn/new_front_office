import 'package:flutter/material.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonStyle{
  static ButtonStyle blueStandard(){
    return ElevatedButton.styleFrom(
        backgroundColor: CustomColorStyle.bluePrimary(),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 14,
        ),
        foregroundColor: Colors.white
    );
  }

  static ButtonStyle cancel(){
    return ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 14,
        ),
        foregroundColor: Colors.white
    );
  }

  static ButtonStyle confirm(){
    return ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 14,
        ),
        foregroundColor: Colors.white
    );
  }

  static ButtonStyle bluePrimary(){
    return ElevatedButton.styleFrom(
        backgroundColor: CustomColorStyle.appBarBackground(),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: GoogleFonts.poppins(
          fontSize: 14,
        ),
        alignment: Alignment.center,
        foregroundColor: Colors.white
    );
  }
}