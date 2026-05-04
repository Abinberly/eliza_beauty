import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_images.dart';
import '../../core/theme/app_theme.dart';
import '../features/product/product_card_shimmer.dart';
import '../providers/shop/shop_providers.dart';
import '../components/common/app_title.dart';
import '../components/common/indicators/carousel_shimmer.dart';
import '../components/common/category_list_bar.dart';
import '../components/common/feature_carousel.dart';
import '../features/product/product_grid.dart';

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
            onPressed: () {
              context.push(AppRoutes.cart);
            },
            icon: Image.asset(AppImages.bagIcon),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsByCategoryProvider);

    final isInitialLoading =
        categoriesAsync.isLoading ||
        (productsAsync.isLoading && !productsAsync.hasValue) ||
        (categoriesAsync.hasValue &&
            productsAsync.valueOrNull?.isEmpty == true &&
            !productsAsync.hasError);

    if (isInitialLoading) {
      return const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                CarouselShimmer(),
                SizedBox(height: 20),
              ],
            ),
          ),
          SliverProductListShimmer(count: 3),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
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
            style: const TextStyle(fontSize: 20, fontWeight: .w600),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
