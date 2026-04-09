import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/presentation/molecules/product_info_section.dart';
import 'package:eliza_beauty/presentation/providers/details_provider.dart';
import 'package:eliza_beauty/presentation/providers/cart_provider.dart';
import 'package:eliza_beauty/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsPage extends ConsumerWidget {
  final int productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.prdDetails,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: .w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAction(context, ref, productAsync),
      body: productAsync.when(
        data: (product) => SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                product.thumbnail,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ProductInfoSection(product: product),
              ),

              _buildReviewList(product.reviews),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${AppConstants.errorPrefix}$e')),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, WidgetRef ref, AsyncValue<ProductModel> productAsync) {
    final cartState = ref.watch(cartNotifierProvider);
    final userAsync = ref.watch(userProfileProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ElevatedButton(
        onPressed: (!productAsync.hasValue || cartState.isLoading)
            ? null
            : () {
                if (userAsync.value == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to add items to cart'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                final user = userAsync.value!;
                final product = productAsync.value!;
                ref.read(cartNotifierProvider.notifier).addItemToCart(user.id, product);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${product.title}${AppConstants.addedToCartSuffix}',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: cartState.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                AppConstants.addToCart,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.card,
                ),
              ),
      ),
    );
  }

  Widget _buildReviewList(List<Review> reviews) {
    return Column(
      children: reviews
          .map(
            (r) => ListTile(
              title: Text(
                r.reviewerName,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: .w600,
                  color: AppColors.textSecondary,
                ),
              ),
              subtitle: Text(
                r.comment,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: .w600,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${r.rating}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: .w600,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(width: 2,),

                  Icon(Icons.star, size: 12,color: AppColors.activeIconBackground,)
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
