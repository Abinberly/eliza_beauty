import 'package:eliza_beauty/core/network/connectivity_provider.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/theme/app_theme.dart';
import 'package:eliza_beauty/presentation/widgets/network_error_dialog.dart';
import 'package:eliza_beauty/presentation/widgets/product_card.dart';
import 'package:eliza_beauty/presentation/providers/shop/shop_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SliverProductList extends ConsumerWidget {
  const SliverProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text(context.l10n.noProductsFound)),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < products.length) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: ProductCard(
                      product: product,
                      onTap: () {
                        final isConnected = ref.read(
                          connectivityNotifierProvider,
                        );
                        if (!isConnected) {
                          NetworkErrorDialog.show(
                            context,
                            onRetry: () async {
                              await ref
                                  .read(connectivityNotifierProvider.notifier)
                                  .refresh();
                              if (!ref.context.mounted) return;

                              if (ref.read(connectivityNotifierProvider)) {
                                context.pushNamed(
                                  AppRoutes.prodDetailsName,
                                  pathParameters: {'id': product.id.toString()},
                                );
                              }
                            },
                          );
                        } else {
                          context.pushNamed(
                            AppRoutes.prodDetailsName,
                            pathParameters: {'id': product.id.toString()},
                          );
                        }
                      },
                    ),
                  );
                } else {
                  final hasMore = ref
                      .watch(productsByCategoryProvider.notifier)
                      .hasMore;
                  return hasMore
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }
              },

              childCount:
                  products.length +
                  (ref.watch(productsByCategoryProvider.notifier).hasMore
                      ? 1
                      : 0),
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(child: Text("${context.l10n.errorPrefix}$error")),
      ),
    );
  }
}
