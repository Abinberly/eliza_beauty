import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const AppTitle({
    super.key,
    required this.title,
    this.fontSize = 60,
    this.color,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        title,
        maxLines: 1,
        style: GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 2,
          height: 1,
          color: effectiveColor,
        ),
      ),
    );
  }
}