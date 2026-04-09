import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/presentation/atoms/product_price_tag.dart';
import 'package:eliza_beauty/presentation/molecules/rating_bar_molecule.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.brand ?? AppConstants.genericBrand, style: GoogleFonts.inter(color: AppColors.textPrimary, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Text(product.title, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        RatingBarMolecule(rating: product.rating, reviewCount: product.reviewCount),
        const SizedBox(height: 16),
        ProductPriceTag(price: product.price, discount: product.discountPercentage),
        const SizedBox(height: 16),
        Text(product.description, style: GoogleFonts.inter(height: 1.5, color: AppColors.textSecondary)),
      ],
    );
  }
}