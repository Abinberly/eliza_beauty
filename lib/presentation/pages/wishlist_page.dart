import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/wishlist_model.dart';
import '../features/product/product_card_skeleton.dart';
import '../providers/wishlist/wishlist_provider.dart';
import '../components/common/app_title.dart';
import '../features/wishlist/wishlist_item_card.dart';

enum WishlistViewMode { grid, list }

final wishlistSearchQueryProvider = StateProvider<String>((ref) => '');

final wishlistViewModeProvider = StateProvider<WishlistViewMode>(
  (ref) => WishlistViewMode.grid,
);

final filteredWishlistProvider = Provider<List<WishlistItem>>((ref) {
  final query = ref.watch(wishlistSearchQueryProvider).toLowerCase();
  final wishlistAsync = ref.watch(wishlistNotifierProvider);

  return wishlistAsync.maybeWhen(
    data: (items) {
      if (query.isEmpty) return items;
      return items
          .where((item) => item.product.title.toLowerCase().contains(query))
          .toList();
    },
    orElse: () => [],
  );
});

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistNotifierProvider);
    final viewMode = ref.watch(wishlistViewModeProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppTitle(title: l10n.wishlist, fontSize: 20),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(wishlistViewModeProvider.notifier)
                .update(
                  (state) => state == WishlistViewMode.grid
                      ? WishlistViewMode.list
                      : WishlistViewMode.grid,
                ),
            icon: Icon(
              viewMode == WishlistViewMode.grid
                  ? Icons.view_list
                  : Icons.grid_view,
            ),
          ),
          const _WishlistMoreMenu(),
        ],
      ),
      body: Column(
        children: [
          const _WishlistSearchBar(),
          Expanded(
            child: wishlistAsync.when(
              data: (_) => const _WishlistContent(),
              loading: () => _LoadingState(viewMode: viewMode),
              error: (error, _) => _ErrorState(message: error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wishlist Search Bar
class _WishlistSearchBar extends ConsumerWidget {
  const _WishlistSearchBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) =>
            ref.read(wishlistSearchQueryProvider.notifier).state = value,
        decoration: InputDecoration(
          hintText: context.l10n.searchWishlist,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

/// Wishlist Content
class _WishlistContent extends ConsumerWidget {
  const _WishlistContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredWishlistProvider);
    final viewMode = ref.watch(wishlistViewModeProvider);

    if (items.isEmpty) return const _EmptyState();

    return viewMode == WishlistViewMode.grid
        ? _WishlistGridView(items: items)
        : _WishlistListView(items: items);
  }
}

class _WishlistGridView extends ConsumerWidget {
  const _WishlistGridView({required this.items});
  final List<WishlistItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 126),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.53,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => WishlistGridItem(
        item: items[index],
        onTap: () {
          context.pushNamed(
            AppRoutes.prodDetailsName,
            pathParameters: {'id': items[index].productId.toString()},
          );
        },
        onRemove: () => ref
            .read(wishlistNotifierProvider.notifier)
            .toggleItem(items[index].product),
      ),
    );
  }
}

class _WishlistListView extends ConsumerWidget {
  const _WishlistListView({required this.items});
  final List<WishlistItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 126),
      itemCount: items.length,
      itemBuilder: (context, index) =>
          WishlistItemCard(item: items[index], onTap: () {
             context.pushNamed(
            AppRoutes.prodDetailsName,
            pathParameters: {'id': items[index].productId.toString()},
          );
          }, onRemove: () => ref
            .read(wishlistNotifierProvider.notifier)
            .toggleItem(items[index].product),),
    );
  }
}

class _WishlistMoreMenu extends ConsumerWidget {
  const _WishlistMoreMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'clear') {
          ref.read(wishlistNotifierProvider.notifier).clearAll();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'clear', child: Text(context.l10n.clearWishlist)),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.viewMode});
  final WishlistViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    if (viewMode == WishlistViewMode.grid) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const SimilarProductCardSkeleton(),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => const SearchItemCardSkeleton(),
    );
  }
}

class _ErrorState extends ConsumerWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(wishlistNotifierProvider);
            },
            child: Text(context.l10n.networkErrorRetry),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            context.l10n.wishlistEmpty,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(context.l10n.wishlistEmptyDesc),
        ],
      ),
    );
  }
}