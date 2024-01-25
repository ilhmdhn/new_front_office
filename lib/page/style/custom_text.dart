import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle{
  static TextStyle titleAlertDialog(){
    return GoogleFonts.poppins(fontSize: 18, color: Colors.black);
  }

  static TextStyle titleAppBar(){
    return GoogleFonts.poppins(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w500);
  }

  static TextStyle whiteStandard(){
    return GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500);
  }

  static TextStyle blackStandard(){
    return GoogleFonts.poppins(fontSize: 14, color: Colors.black);
  }

  static TextStyle blackMedium(){
    return GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500);
  }

  static TextStyle blackSemi(){
    return GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600);
  }
}