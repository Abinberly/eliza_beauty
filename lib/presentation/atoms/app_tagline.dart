import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTagline extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const AppTagline({
    super.key,
    required this.title,
    this.fontSize = 14,
    this.color = AppColors.textSecondary,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        title,
        maxLines: 1,
        style: GoogleFonts.inter(fontSize: fontSize, color: color, fontWeight: fontWeight),
      ),
    );
  }
}
