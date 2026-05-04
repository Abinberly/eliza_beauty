import '../../core/network/connectivity_provider.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_images.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/alert_service.dart';
import '../../data/models/product_model.dart' as pm;
import '../../data/models/wishlist_model.dart';
import '../providers/wishlist/wishlist_provider.dart';
import '../components/common/app_title.dart';
import '../components/common/error_view.dart';
import '../components/overlays/network_error_dialog.dart';
import '../features/product/similar_product_card.dart';
import '../features/product/product_header_section.dart';
import '../features/product/product_image_gallery.dart';
import '../components/common/rating_row.dart';
import '../features/product/product_extra_details.dart';
import '../providers/shop/details_provider.dart';
import '../providers/cart/cart_provider.dart';
import '../providers/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final userAsync = ref.watch(userProfileProvider);

    Future<void> refreshCart() async {
      return ref.refresh(cartNotifierProvider.future);
    }

    // Connectivity changes Listening
    ref.listen<bool>(connectivityNotifierProvider, (previous, isConnected) {
      if (previous == false && isConnected == true) {
        refreshCart();
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AppTitle(
          title: l10n.prdDetails,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          IconButton(
            onPressed: () {
              final isConnected = ref.read(connectivityNotifierProvider);
              if (!isConnected) {
                NetworkErrorDialog.show(
                  context,
                  onRetry: () async {
                    await ref
                        .read(connectivityNotifierProvider.notifier)
                        .refresh();
                    if (!ref.context.mounted) return;

                    if (ref.read(connectivityNotifierProvider)) {
                      context.push(AppRoutes.cart);
                    }
                  },
                );
              } else {
                context.push(AppRoutes.cart);
              }
            },
            icon: Image.asset(AppImages.bagIcon),
          ),
          const SizedBox(width: 20),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: refreshCart,
        child: productAsync.when(
          data: (product) {
            final isWishlisted = ref.watch(isProductWishlistedProvider(product.id));
            return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [

                    ProductImageGallery(images: product.images),
                
                    Positioned(
                      top: 16,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 30,
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
                  ],
                ),

                const SizedBox(height: 24),

                ProductHeaderSection(
                  title: product.title,
                  price: product.price,
                  discount: product.discountPercentage,
                ),

                const SizedBox(height: 4),

                RatingRow(rating: product.rating, count: product.reviewCount),

                const SizedBox(height: 20),
                Text(
                  product.description,
                  style: GoogleFonts.poppins(color: Colors.grey, height: 1.5),
                  textAlign: .start,
                ),

                const SizedBox(height: 30),

                _buildBottomAction(context, ref, productAsync),

                const SizedBox(height: 12),

                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.buyNow,
                    style: GoogleFonts.inter(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: .w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ProductExtraDetails(product: product),

                const SizedBox(height: 20),
                Text(
                  l10n.customerExperience,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                _buildReviewList(product.reviews),

                const SizedBox(height: 16),

                _buildSimilarProducts(
                  context,
                  ref,
                  product.category,
                  product.id,
                ),
              ],
            ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorView(
            message: error.toString().contains('timed out')
                ? context.l10n.connectionTimeout
                : context.l10n.somethingWentWrong,
            onRetry: refreshCart,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<pm.ProductModel> productAsync,
  ) {
    final cartState = ref.watch(cartNotifierProvider);
    final userAsync = ref.watch(userProfileProvider);

    return ElevatedButton(
      onPressed: (!productAsync.hasValue || cartState.isLoading)
          ? null
          : () {
              if (userAsync.value == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.loginToAddToCart),
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }

              final user = userAsync.value!;
              final product = productAsync.value!;
              ref
                  .read(cartNotifierProvider.notifier)
                  .addItemToCart(user.id, product);

              AlertService.showSuccess(
                context,
                '${product.title}${context.l10n.addedToCartSuffix}',
              );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              cartState.isLoading
                  ? context.l10n.adding
                  : context.l10n.addToCart,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.card,
              ),
            ),
    );
  }

  Widget _buildReviewList(List<pm.Review> reviews) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 16,
                        color: i < review.rating
                            ? Colors.orange
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${review.comment}"',
                    style: GoogleFonts.poppins(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.reviewerName,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimilarProducts(
    BuildContext context,
    WidgetRef ref,
    String category,
    int currentProductId,
  ) {
    final similarAsync = ref.watch(similarProductsProvider(category));
    return similarAsync.when(
      data: (products) {
        final filtered = products
            .where((p) => p.id != currentProductId)
            .toList();
        if (filtered.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.similarProducts,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return SimilarProductCard(product: filtered[index]);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('${context.l10n.errorPrefix}$e')),
    );
  }
}
