import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthNavigationLink extends StatelessWidget {
  final String label;
  final String actionText;

  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  final double btnFontSize;
  final Color btnTxtColor;
  final FontWeight btnFontWeight;

  final VoidCallback onActionPressed;

  const AuthNavigationLink({
    super.key,
    required this.label,
    required this.actionText,
    required this.onActionPressed,
    this.fontSize = 14,
    this.color = AppColors.textSecondary,
    this.fontWeight = FontWeight.normal,
    this.btnFontSize = 14,
    this.btnTxtColor = AppColors.warning,
    this.btnFontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ),

        const SizedBox(width: 4),

        TextButton(
          onPressed: onActionPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: btnFontSize,
              color: btnTxtColor,
              fontWeight: btnFontWeight,
            ),
          ),
        ),
      ],
    );
  }
}
