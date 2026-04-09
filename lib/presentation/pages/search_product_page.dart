import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/presentation/atoms/app_title.dart';
import 'package:eliza_beauty/presentation/atoms/search_bar_field.dart';
import 'package:eliza_beauty/presentation/molecules/sort_filter_bar.dart';
import 'package:eliza_beauty/presentation/providers/product_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchProductPage extends HookConsumerWidget {
  const SearchProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final state = ref.watch(productSearchControllerProvider);
    final notifier = ref.read(productSearchControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AppTitle(
          title: "Search product",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
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
                    ? const Center(child: CircularProgressIndicator())
                    : state.products.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No items found matching "${state.query}"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => notifier.fetchProducts(),
                        child: ListView.builder(
                          itemCount:
                              state.products.length +
                              (state.isLoadMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.products.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final product = state.products[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.thumbnail,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(product.title),
                              subtitle: Text("\$${product.price}"),
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.prodDetailsName,
                                  pathParameters: {'id': product.id.toString()},
                                );
                              },
                            );
                          },
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
