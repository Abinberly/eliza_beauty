import '../../../../core/theme/app_theme.dart';
import '../../components/common/indicators/skeleton_loader.dart';
import 'cart_item_card.dart';
import '../../providers/cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartList extends ConsumerWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);
    final l10n = context.l10n;

    return cartState.when(
      data: (carts) {
        final allProducts = carts.expand((cart) => cart.products).toList();

        if (allProducts.isEmpty && !cartState.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.cartEmpty,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.addItemsToCartContinue,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
          itemCount: allProducts.length + (cartState.isLoading ? 1 : 0),
          cacheExtent: 500, // Cache items for smooth scrolling
          addAutomaticKeepAlives: true, // Keep items alive for better performance
          addRepaintBoundaries: true, // Optimize repainting
          addSemanticIndexes: true, // Enable semantic indexing
          itemBuilder: (context, index) {
            if (index == allProducts.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final product = allProducts[index];
            final cart = carts.firstWhere(
              (c) => c.products.any((p) => p.id == product.id),
            );

            return CartItemCard(
              key: ValueKey('cart_item_${product.id}'), // Unique key for optimization
              product: product,
              onQuantityChanged: (newQty) {
                ref
                    .read(cartNotifierProvider.notifier)
                    .updateItemQuantity(cart.id, product.id, newQty);
              },
              onDelete: () {
                ref
                    .read(cartNotifierProvider.notifier)
                    .removeProduct(cart.id, product.id);
              },
            );
          },
        );
      },
      loading: () => _buildShimmerLoading(),
      error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, _) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: SkeletonLoader(width: double.infinity, height: 300),
      ),
    );
  }
}
