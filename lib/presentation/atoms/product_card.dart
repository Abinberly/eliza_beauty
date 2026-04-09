import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/presentation/molecules/rating_row.dart';
import 'package:eliza_beauty/presentation/providers/cart_provider.dart';
import 'package:eliza_beauty/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);
    final userAsync = ref.watch(userProfileProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.network(
                    product.thumbnail,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: .ellipsis,
                          maxLines: 1,
                        ),
                      ),

                      Text(
                        "\$${product.price}",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D4ED8),
                        ),
                        overflow: .ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  RatingRow(rating: product.rating, count: product.reviewCount),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: cartState.isLoading
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
                              ref
                                  .read(cartNotifierProvider.notifier)
                                  .addItemToCart(user.id, product);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.title}${AppConstants.addedToCartSuffix}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                      icon: cartState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.shopping_cart_outlined),
                      label: Text(
                        cartState.isLoading
                            ? 'Adding...'
                            : AppConstants.addToCart,
                        style: GoogleFonts.inter(
                          fontWeight: .bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
