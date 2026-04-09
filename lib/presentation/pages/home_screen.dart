import 'package:eliza_beauty/core/constants/app_constants.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/theme/app_images.dart';
import 'package:eliza_beauty/presentation/atoms/app_title.dart';
import 'package:eliza_beauty/presentation/molecules/category_list_bar.dart';
import 'package:eliza_beauty/presentation/molecules/promo_card.dart';
import 'package:eliza_beauty/presentation/organisms/product_grid.dart';
import 'package:eliza_beauty/presentation/providers/shop_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productsByCategoryProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: AppTitle(
            title: AppConstants.appTitle,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.cart),
            icon: Icon(Icons.shopping_cart),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const PromoCard(imagePath: AppImages.cardBg),
                    const SizedBox(height: 20),
                    const CategoryListBar(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            const SliverProductList(),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
