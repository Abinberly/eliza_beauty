import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingBarMolecule extends StatelessWidget {

  const RatingBarMolecule({
    super.key,
    required this.rating,
    required this.reviewCount,
  });
  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.secondary, size: 20),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(
          '($reviewCount${context.l10n.reviewsSuffix})',
          style: GoogleFonts.inter(color: AppColors.textSecondaryDark),
        ),
      ],
    );
  }
}
