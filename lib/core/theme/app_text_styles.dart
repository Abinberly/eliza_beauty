import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextTheme getLightTextTheme() {
    return GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme);
  }

  static TextTheme getDarkTextTheme() {
    return GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);
  }
}
