import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/core/network/connectivity_provider.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/data/models/product_search_state.dart';
import 'package:eliza_beauty/data/repositories/local_cache_repository.dart';
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
    if (state.isLoading) return;

    final newSkip = isNextPage ? state.products.length : 0;

    state = state.copyWith(
      isLoading: !isNextPage,
      isLoadMore: isNextPage,
      skip: newSkip,
    );

    final isOnline = ref.read(connectivityNotifierProvider);

    if (!isOnline) {
      // Offline — try loading from cache
      await _loadFromCache();
      return;
    }

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

        final allProducts = isNextPage
            ? [...state.products, ...newProducts]
            : newProducts;

        state = state.copyWith(
          products: allProducts,
          total: data['total'] ?? 0,
          isLoading: false,
          isLoadMore: false,
        );

        // Cache results for offline use
        try {
          final cacheRepo = ref.read(localCacheRepositoryProvider);
          await cacheRepo.cacheSearchResults(
            query: state.query,
            sortBy: state.sortBy,
            order: state.order,
            products: allProducts,
          );
        } catch (e) {
          log('Failed to cache search results: $e', name: 'SearchProvider');
        }
      } else {
        state = state.copyWith(isLoading: false, isLoadMore: false);
      }
    } catch (e) {
      log('Search API failed, loading from cache: $e', name: 'SearchProvider');
      await _loadFromCache();
    }
  }

  Future<void> _loadFromCache() async {
    try {
      final cacheRepo = ref.read(localCacheRepositoryProvider);
      final cached = await cacheRepo.getCachedSearchResults(
        query: state.query,
        sortBy: state.sortBy,
        order: state.order,
      );

      if (cached.isNotEmpty) {
        state = state.copyWith(
          products: cached,
          total: cached.length,
          isLoading: false,
          isLoadMore: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoadMore: false,
          products: [],
        );
      }
    } catch (e) {
      log('Failed to load cached search: $e', name: 'SearchProvider');
      state = state.copyWith(isLoading: false, isLoadMore: false);
    }
  }

  void updateQuery(String query) {
    _debounceTimer?.cancel();
    if (query.isEmpty) {
      state = state.copyWith(
        query: '',
        products: [],
        skip: 0,
        isLoading: false,
      );
      fetchProducts();
      return;
    }

    state = state.copyWith(query: query, products: [], skip: 0);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchProducts();
    });
  }

  void updateSort(String sortBy, String order) {
    state = state.copyWith(sortBy: sortBy, order: order, products: [], skip: 0);
    fetchProducts();
  }
}
