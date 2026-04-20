import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/theme/app_images.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/atoms/app_title.dart';
import 'package:eliza_beauty/presentation/molecules/carousel_shimmer.dart';
import 'package:eliza_beauty/presentation/molecules/category_list_bar.dart';
import 'package:eliza_beauty/presentation/molecules/product_card_shimmer.dart';
import 'package:eliza_beauty/presentation/organisms/feature_carousel.dart';
import 'package:eliza_beauty/presentation/organisms/product_grid.dart';
import 'package:eliza_beauty/presentation/providers/shop/shop_providers.dart';
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
    final constants = context.l10n;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppTitle(
          title: constants.appTitle,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),

        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.cart),
            icon: Image.asset(AppImages.bagIcon),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsByCategoryProvider);

    final isInitialLoading = categoriesAsync.isLoading ||
        (productsAsync.isLoading && !productsAsync.hasValue) ||
        (categoriesAsync.hasValue && productsAsync.valueOrNull?.isEmpty == true && !productsAsync.hasError);

    if (isInitialLoading) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CarouselShimmer(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SliverProductListShimmer(count: 3),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const FeatureCarousel(),
              const SizedBox(height: 20),
              _categoriesTitle(),
              const SizedBox(height: 6),
              const CategoryListBar(),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SliverProductList(),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _categoriesTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text(
            context.l10n.categories,
            style: TextStyle(fontSize: 20, fontWeight: .w600),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
