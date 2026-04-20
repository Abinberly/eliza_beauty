import 'dart:developer';

import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/core/network/network_info.dart';
import 'package:eliza_beauty/data/models/category_model.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/data/repositories/local_cache_repository.dart';
import 'package:eliza_beauty/data/sources/product_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_providers.g.dart';

@riverpod
Future<List<CategoryModel>> categories(Ref ref) async {
  final client = ref.watch(chopperClientProvider);
  final service = client.getService<ProductApiService>();
  final cacheRepo = ref.read(localCacheRepositoryProvider);
  final hasInternet = await NetworkInfo.isConnected();

  if (hasInternet) {
    try {
      final response = await service.getCategories();

      if (response.isSuccessful && response.body != null) {
        final list = (response.body as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        
        try {
          await cacheRepo.cacheCategories(list);
        } catch (cacheErr) {
          log('Failed to cache categories: $cacheErr', name: 'ShopProviders');
        }
        return list;
      }
    } catch (e) {
      log('Categories API failed, loading from cache. Error: $e', name: 'ShopProviders');
    }
  }

  // Fallback to offline cache
  try {
    final cachedCategories = await cacheRepo.getCachedCategories();
    if (cachedCategories.isNotEmpty) {
      return cachedCategories;
    }
  } catch (e) {
    log('Failed to load cached categories: $e', name: 'ShopProviders');
  }

  throw Exception("Failed to fetch categories and no local cache available");
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.maybeWhen(
      data: (list) => list.isNotEmpty ? list.first.slug : "",
      orElse: () => "",
    );
  }

  void select(String slug) => state = slug;
}

@riverpod
class ProductsByCategory extends _$ProductsByCategory {
  int _skip = 0;
  final int _limit = 16;
  bool _hasMore = true;

  @override
  Future<List<ProductModel>> build() async {
    final slug = ref.watch(selectedCategoryProvider);
    if (slug.isEmpty) return [];

    _skip = 0;
    _hasMore = true;
    final initialItems = await _fetchPage(slug);
    
    final cacheRepo = ref.read(localCacheRepositoryProvider);
    if (initialItems.isNotEmpty) {
      try {
        await cacheRepo.cacheProducts(slug, initialItems);
      } catch (cacheErr) {
        log('Failed to cache products: $cacheErr', name: 'ShopProviders');
      }
      return initialItems;
    } else {
      try {
        final cachedProducts = await cacheRepo.getCachedProducts(slug);
        if (cachedProducts.isNotEmpty) {
          _hasMore = false; // Cannot fetch next page offline easily
          return cachedProducts;
        }
      } catch (e) {
        log('Failed to load cached products: $e', name: 'ShopProviders');
      }
    }
    
    return [];
  }

  Future<List<ProductModel>> _fetchPage(String slug) async {
    final client = ref.read(chopperClientProvider);
    final service = client.getService<ProductApiService>();
    
    final hasInternet = await NetworkInfo.isConnected();

    if (hasInternet) {
      try {
        final response = await service.getProductsByCategory(
          slug,
          limit: _limit,
          skip: _skip,
        );

        if (response.isSuccessful && response.body != null) {
          final List<dynamic> productsJson = response.body!['products'];
          final total = response.body!['total'] ?? 0;
          
          final newItems = productsJson.map((json) => ProductModel.fromJson(json)).toList();
          
          if (_skip + newItems.length >= total) {
            _hasMore = false;
          }
          
          return newItems;
        }
      } catch (e) {
        log('Products API failed: $e', name: 'ShopProviders');
      }
    }
    return [];
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !_hasMore) return;

    final slug = ref.read(selectedCategoryProvider);
    _skip += _limit;

    final previousData = state.value ?? [];

    state = const AsyncLoading<List<ProductModel>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      final nextItems = await _fetchPage(slug);
      final combinedItems = [...previousData, ...nextItems];
      
      if (nextItems.isNotEmpty) {
        try {
          await ref.read(localCacheRepositoryProvider).cacheProducts(slug, combinedItems);
        } catch (cacheErr) {
          // Cache failure is non-critical; next launch will re-fetch.
        }
      }
      
      return combinedItems;
    });
  }

  bool get hasMore => _hasMore;
}