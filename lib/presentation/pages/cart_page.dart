import 'package:eliza_beauty/presentation/atoms/app_title.dart';
import 'package:eliza_beauty/presentation/organisms/cart_list.dart';
import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/theme/app_colors.dart';
import 'package:eliza_beauty/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false,
        title: AppTitle(
          title: "My Cart",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),

      body: CartList(),
      bottomNavigationBar: _buildBottomCheckout(context, ref),
    );
  }

  Widget? _buildBottomCheckout(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartNotifierProvider);
    
    if (cartState.isLoading || cartState.hasError || cartState.value == null) {
      return null;
    }
    
    final carts = cartState.value!;
    final allProducts = carts.expand((c) => c.products).toList();
    
    if (allProducts.isEmpty) {
      return null; 
    }

    final total = carts.fold(0.0, (sum, c) => sum + c.total);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Price",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppConstants.checkout,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.card,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}