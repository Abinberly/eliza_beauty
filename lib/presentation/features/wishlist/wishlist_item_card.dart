import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/wishlist_model.dart';
import '../../components/common/rating_row.dart';
import '../../components/media/app_network_image.dart';

/// Wishlist item card for list view
class WishlistItemCard extends ConsumerWidget {
  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
  });
  final WishlistItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final product = item.product;
    final offPrice = _calculateDiscountedPrice(
      product.price,
      product.discountPercentage,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppNetworkImage(
                  imageUrl: product.thumbnail,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      product.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Category
                    Text(
                      product.category,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${offPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    RatingRow(
                      rating: product.rating,
                      count: product.reviews.length,
                    ),
                    const SizedBox(height: 8),

                    // Added date and remove button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(context, item.addedAt),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          tooltip: context.l10n.removeTooltip,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateDiscountedPrice(double price, double discountPercentage) {
    if (!price.isFinite || price.isNaN) return price;
    if (!discountPercentage.isFinite || discountPercentage.isNaN) return price;
    if (discountPercentage < 0 || discountPercentage > 100) return price;

    final discountAmount = price * (discountPercentage / 100);
    final discountedPrice = price - discountAmount;

    if (!discountedPrice.isFinite ||
        discountedPrice.isNaN ||
        discountedPrice < 0) {
      return price;
    }

    return discountedPrice;
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return l10n.addedDaysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return l10n.addedHoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return l10n.addedMinutesAgo(difference.inMinutes);
    } else {
      return l10n.addedJustNow;
    }
  }
}

/// Wishlist item for grid view
class WishlistGridItem extends StatelessWidget {
  const WishlistGridItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
  });
  final WishlistItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final product = item.product;
    final offPrice = _calculateDiscountedPrice(
      product.price,
      product.discountPercentage,
    );

    return Container(
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColoredBox(
              color: AppColors.lightGray,
              child: Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: AppNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
              
                  // Remove button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              
                  // Discount badge
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
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

            // Product details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Category
                  Text(
                    product.category,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${offPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Rating
                  RatingRow(
                    rating: product.rating,
                    count: product.reviews.length,
                    isSearchView: true,
                  ),
                  const SizedBox(height: 4),

                  // Added date
                  Text(
                    _formatDate(context, item.addedAt),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.grey[500],
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

  double _calculateDiscountedPrice(double price, double discountPercentage) {
    if (!price.isFinite || price.isNaN) return price;
    if (!discountPercentage.isFinite || discountPercentage.isNaN) return price;
    if (discountPercentage < 0 || discountPercentage > 100) return price;

    final discountAmount = price * (discountPercentage / 100);
    final discountedPrice = price - discountAmount;

    if (!discountedPrice.isFinite ||
        discountedPrice.isNaN ||
        discountedPrice < 0) {
      return price;
    }

    return discountedPrice;
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return l10n.addedDaysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return l10n.addedHoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return l10n.addedMinutesAgo(difference.inMinutes);
    } else {
      return l10n.addedJustNow;
    }
  }
}
