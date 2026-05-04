import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCapsule extends StatelessWidget {

  const CategoryCapsule({super.key, required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final colorScheme = context.customColors;
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: isSelected ? AppColors.primary : colorScheme.capsuleBg,
      labelStyle: GoogleFonts.inter(fontSize: 14, color: isSelected ? AppColors.textPrimaryDark : theme.onSurface),
      shape: const StadiumBorder(),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }
}
