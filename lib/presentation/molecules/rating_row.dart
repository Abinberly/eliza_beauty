import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingRow extends StatelessWidget {
  final double rating;
  final int count;
  final bool isSearchView;
  const RatingRow({
    super.key,
    required this.rating,
    required this.count,
    this.isSearchView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isSearchView)
          const Icon(Icons.star, color: AppColors.mustardYellow, size: 18)
        else
          Row(
            children: List.generate(5, (index) {
              if (index < rating.floor()) {
                return const Icon(
                  Icons.star,
                  color: AppColors.mustardYellow,
                  size: 18,
                );
              } else if (index < rating && (rating - index) >= 0.1) {
                return const Icon(
                  Icons.star_half,
                  color: AppColors.mustardYellow,
                  size: 18,
                );
              } else {
                return const Icon(
                  Icons.star_outline,
                  color: AppColors.mustardYellow,
                  size: 18,
                );
              }
            }),
          ),

        const SizedBox(width: 4),
        Text(
          context.l10n.ratingSummary(count, rating),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
