import '../../../../core/network/connectivity_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/alert_service.dart';
import '../../../../data/models/product_model.dart';
import '../../components/media/app_network_image.dart';
import '../../components/common/rating_row.dart';
import 'product_card.dart';
import '../../providers/cart/cart_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/wishlist/wishlist_provider.dart';
import '../../../../data/models/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SimilarProductCard extends ConsumerWidget {
  const SimilarProductCard({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final cartState = ref.watch(cartNotifierProvider);
    final userAsync = ref.watch(userProfileProvider);
    final isWishlisted = ref.watch(isProductWishlistedProvider(product.id));

    final double offPrice = ProductCard.calculateDiscountedPrice(product.price, product.discountPercentage);

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.prodDetailsName,
        pathParameters: {'id': product.id.toString()},
      ),
      child: Container(
        width: 160,
        height: 280,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 120,
              child: ColoredBox(
                color: AppColors.lightGray,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.5),
                        radius: 12,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            size: 14,
                            color: isWishlisted 
                                ? Colors.red 
                                : AppColors.error.withValues(alpha: 0.8),
                          ),
                          onPressed: () async {
                            if (userAsync.value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.loginToAddToWishlist),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            await ref
                                .read(wishlistNotifierProvider.notifier)
                                .toggleItem(product.toProductInfo());

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isWishlisted
                                        ? l10n.removedFromWishlist(product.title)
                                        : '${product.title} ${l10n.addedToWishlist}',
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
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercentage.round()}% OFF',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '\$${ProductCard.safeDoubleToString(offPrice)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${ProductCard.safeDoubleToString(product.price)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: theme.hintColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  RatingRow(
                    rating: product.rating,
                    count: product.reviewCount,
                    isSearchView: true,
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 32,
              child: FilledButton(
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
                              content: Text(l10n.loginToAddToCart),
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
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  cartState.isLoading ? l10n.adding : l10n.addToCart,
                  style: GoogleFonts.inter(
                    fontWeight: .w600,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
