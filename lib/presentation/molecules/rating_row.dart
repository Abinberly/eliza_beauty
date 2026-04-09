import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingRow extends StatelessWidget {
  final double rating;
  final int count;
  const RatingRow({super.key, required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.mustardYellow, size: 18),
        const SizedBox(width: 4),
        Text(
          "$rating ($count Reviews)",
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
