import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingBarMolecule extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingBarMolecule({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.secondary, size: 20),
        const SizedBox(width: 4),
        Text(rating.toString(), style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Text('($reviewCount${AppConstants.reviewsSuffix})', style: GoogleFonts.inter(color: AppColors.textSecondaryDark)),
      ],
    );
  }
}