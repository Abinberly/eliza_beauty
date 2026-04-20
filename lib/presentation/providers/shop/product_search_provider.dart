import 'dart:async';
import 'dart:convert';
import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/data/models/product_search_state.dart';
import 'package:eliza_beauty/data/sources/product_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_search_provider.g.dart';

@riverpod
class ProductSearchController extends _$ProductSearchController {
  Timer? _debounceTimer;

  @override
  ProductSearchState build() {
    ref.onDispose(() => _debounceTimer?.cancel());

    Future.microtask(() => fetchProducts());

    return const ProductSearchState();
  }

  Future<void> fetchProducts({bool isNextPage = false}) async {
    if (state.isLoading || (isNextPage && state.hasReachedMax)) return;

    final newSkip = isNextPage ? state.products.length : 0;

    state = state.copyWith(
      isLoading: !isNextPage,
      isLoadMore: isNextPage,
      skip: newSkip,
    );

    final client = ref.read(chopperClientProvider);
    final service = client.getService<ProductApiService>();

    try {
      final response = await service.searchProducts(
        query: state.query,
        limit: state.limit,
        skip: state.skip,
        sortBy: state.sortBy,
        order: state.order,
      );

      if (response.isSuccessful && response.body != null) {
        final dynamic rawBody = response.body;
        Map<String, dynamic> data;
        
        if (rawBody is String) {
          data = jsonDecode(rawBody);
        } else {
          data = rawBody as Map<String, dynamic>;
        }
        
        final List rawList = data['products'] ?? [];
        final List<ProductModel> newProducts = rawList
            .map((e) => ProductModel.fromJson(e))
            .toList();

        state = state.copyWith(
          products: isNextPage
              ? [...state.products, ...newProducts]
              : newProducts,
          total: data['total'] ?? 0,
          isLoading: false,
          isLoadMore: false,
        );
      } else {
        state = state.copyWith(isLoading: false, isLoadMore: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isLoadMore: false);
    }
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query, products: [], skip: 0);

    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchProducts();
    });
  }

  void updateSort(String sortBy, String order) {
    state = state.copyWith(sortBy: sortBy, order: order, products: [], skip: 0);
    fetchProducts();
  }
}
