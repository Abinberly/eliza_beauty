import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/network/connectivity_provider.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_images.dart';
import '../../core/theme/app_theme.dart';
import '../features/search/search_card_shimmer.dart';
import '../features/search/search_skeleton.dart';
import '../providers/shop/product_search_provider.dart';
import '../components/common/app_title.dart';
import '../components/overlays/network_error_dialog.dart';
import '../features/search/search_bar_field.dart';
import '../features/search/search_item_card.dart';
import '../components/common/sort_filter_bar.dart';

class SearchProductPage extends HookConsumerWidget {
  const SearchProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final state = ref.watch(productSearchControllerProvider);
    final notifier = ref.read(productSearchControllerProvider.notifier);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppTitle(
          title: l10n.searchProduct,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBarField(
              onChanged: notifier.updateQuery,
              controller: searchController,
            ),

            const SortFilterBar(),

            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200) {
                    notifier.fetchProducts(isNextPage: true);
                  }
                  return false;
                },
                child: state.isLoading
                    ? const SearchResultsGridSkeleton(itemCount: 6)
                    : RefreshIndicator(
                        onRefresh: () => notifier.fetchProducts(),
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            if (state.products.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: context.colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.noItemsFound(state.query),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: context.colorScheme.onSurface
                                              .withValues(alpha: 0.4),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else ...[
                              SliverPadding(
                                padding: const EdgeInsets.all(16.0),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 0.62,
                                      ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final product = state.products[index];
                                      return SearchItemCard(
                                        key: ValueKey(
                                          'search_item_${product.id}',
                                        ),
                                        product: product,
                                      );
                                    },
                                    childCount: state.products.length,
                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: true,
                                    addSemanticIndexes: true,
                                  ),
                                ),
                              ),

                              if (state.isLoadMore)
                                SliverPadding(
                                  padding: const EdgeInsets.all(16.0),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 0.62,
                                        ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) =>
                                          const SearchCardShimmer(),
                                      childCount: 10,
                                      addAutomaticKeepAlives: false,
                                      addRepaintBoundaries: true,
                                      addSemanticIndexes: false,
                                    ),
                                  ),
                                ),

                              const SliverToBoxAdapter(
                                child: SizedBox(height: 80),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
