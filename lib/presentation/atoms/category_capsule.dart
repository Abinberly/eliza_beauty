import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCapsule extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCapsule({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: isSelected ? AppColors.primary : AppColors.lightGray,
      labelStyle: GoogleFonts.inter(fontSize: 14, color: isSelected ? AppColors.textPrimaryDark : AppColors.textPrimary),
      shape: const StadiumBorder(),
      side: BorderSide.none,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }
}