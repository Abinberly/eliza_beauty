

import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/presentation/atoms/nav_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBarItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.label,
    this.icon,
    this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 0.0 : 1.0,
              child: NavIcon(
                icon: icon,
                imageUrl: imageUrl,
                color: AppColors.iconUnselected,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected
                    ? Colors.white
                    : AppColors.textUnselected.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
