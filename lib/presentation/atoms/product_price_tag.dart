import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPriceTag extends StatelessWidget {
  final double price;
  final double? discount;

  const ProductPriceTag({super.key, required this.price, this.discount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('\$${price.toStringAsFixed(2)}', 
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.success)),
        if (discount != null)
          Text('$discount% ${AppConstants.off}', style: GoogleFonts.inter(color: AppColors.error, fontWeight: FontWeight.w600)),
      ],
    );
  }
}