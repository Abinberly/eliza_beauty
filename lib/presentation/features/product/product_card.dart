import '../../../../core/network/connectivity_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/wishlist_model.dart';
import '../../components/media/app_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/alert_service.dart';
import '../../../../data/models/product_model.dart';
import '../../components/common/rating_row.dart';
import '../../providers/cart/cart_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/wishlist/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends ConsumerWidget {

  const ProductCard({super.key, required this.product, required this.onTap});
  final ProductModel product;
  final VoidCallback onTap;

  static double calculateDiscountedPrice(double price, double discountPercentage) {
    if (!price.isFinite || price.isNaN) {
      return 0.0;
    }
    if (!discountPercentage.isFinite || discountPercentage.isNaN) {
      return price;
    }
    if (discountPercentage < 0 || discountPercentage > 100) {
      return price;
    }

    final discountAmount = price * (discountPercentage / 100);
    final discountedPrice = price - discountAmount;
    
    if (!discountedPrice.isFinite || discountedPrice.isNaN || discountedPrice < 0) {
      return price;
    }
    
    return discountedPrice;
  }

  static String safeDoubleToString(double value) {
    if (!value.isFinite || value.isNaN) {
      return '0.00';
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);
    final userAsync = ref.watch(userProfileProvider);
    final isWishlisted = ref.watch(isProductWishlistedProvider(product.id));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double offPrice = calculateDiscountedPrice(product.price, product.discountPercentage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
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
            ColoredBox(
              color: AppColors.lightGray,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: AppNetworkImage(
                      imageUrl: product.thumbnail,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.4),
                      radius: 18,
                      child: IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isWishlisted 
                              ? Colors.red 
                              : AppColors.error.withValues(alpha: 0.8),
                        ),
                        onPressed: () async {
                          if (userAsync.value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text(context.l10n.loginToAddToWishlist),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                         await ref
                              .read(wishlistNotifierProvider.notifier)
                              .toggleItem(product.toProductInfo(),
                              );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isWishlisted 
                                      ? context.l10n.removedFromWishlist(product.title)
                                      : '${product.title} ${context.l10n.addedToWishlist}',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${product.discountPercentage.round()}% ${context.l10n.off}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: .ellipsis,
                    maxLines: 1,
                  ),

                  const SizedBox(height: 4),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '\$${safeDoubleToString(offPrice)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${safeDoubleToString(product.price)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: theme.hintColor,
                        ),
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
                              final isConnected = ref.read(
                                connectivityNotifierProvider,
                              );
                              if (!isConnected) {
                                return;
                              }
                              if (userAsync.value == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.l10n.loginToAddToCart,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

                              final user = userAsync.value!;
                              ref
                                  .read(cartNotifierProvider.notifier)
                                  .addItemToCart(user.id, product);

                              AlertService.showSuccess(
                                context,
                                '${product.title}${context.l10n.addedToCartSuffix}',
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
                            ? context.l10n.adding
                            : context.l10n.addToCart,
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
