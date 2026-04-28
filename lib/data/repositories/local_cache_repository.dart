import 'dart:convert';
import 'package:eliza_beauty/data/local/database_helper.dart';
import 'package:eliza_beauty/data/models/category_model.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_cache_repository.g.dart';

class LocalCacheRepository {
  final DatabaseHelper _dbHelper;

  LocalCacheRepository(this._dbHelper);

  // ── Categories ──────────────────────────────────────────

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    
    // Clear existing for fresh insert
    batch.delete('categories');
    
    for (var cat in categories) {
      batch.insert('categories', cat.toJson());
    }
    
    await batch.commit(noResult: true);
  }

  Future<List<CategoryModel>> getCachedCategories() async {
    final db = await _dbHelper.database;
    final result = await db.query('categories');
    return result.map((json) => CategoryModel.fromJson(json)).toList();
  }

  // ── Products by Category ────────────────────────────────

  Future<void> cacheProducts(String categorySlug, List<ProductModel> products) async {
    final db = await _dbHelper.database;
    final batch = db.batch();

    // delete old cached products for this category to replace with fresh list
    batch.delete('products', where: 'categorySlug = ?', whereArgs: [categorySlug]);

    for (var prod in products) {
      batch.insert('products', {
        'id': prod.id,
        'categorySlug': categorySlug,
        'productJson': jsonEncode(prod.toJson()),
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<ProductModel>> getCachedProducts(String categorySlug) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'products',
      where: 'categorySlug = ?',
      whereArgs: [categorySlug],
    );

    return result.map((row) {
      final jsonStr = row['productJson'] as String;
      return ProductModel.fromJson(jsonDecode(jsonStr));
    }).toList();
  }

  // ── Search Results ──────────────────────────────────────

  Future<void> cacheSearchResults({
    required String query,
    required String sortBy,
    required String order,
    required List<ProductModel> products,
  }) async {
    final db = await _dbHelper.database;

    // Clear old cache for this query+sort combo
    await db.delete(
      'search_cache',
      where: 'query = ? AND sortBy = ? AND orderBy = ?',
      whereArgs: [query, sortBy, order],
    );

    final batch = db.batch();
    final now = DateTime.now().millisecondsSinceEpoch;

    for (var prod in products) {
      batch.insert('search_cache', {
        'query': query,
        'sortBy': sortBy,
        'orderBy': order,
        'productJson': jsonEncode(prod.toJson()),
        'cachedAt': now,
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<ProductModel>> getCachedSearchResults({
    required String query,
    required String sortBy,
    required String order,
  }) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'search_cache',
      where: 'query = ? AND sortBy = ? AND orderBy = ?',
      whereArgs: [query, sortBy, order],
      orderBy: 'id ASC',
    );

    return result.map((row) {
      final jsonStr = row['productJson'] as String;
      return ProductModel.fromJson(jsonDecode(jsonStr));
    }).toList();
  }

  /// Clears search cache older than 24 hours.
  Future<void> clearStaleSearchCache() async {
    final db = await _dbHelper.database;
    final cutoff = DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch;
    await db.delete('search_cache', where: 'cachedAt < ?', whereArgs: [cutoff]);
  }
}

@riverpod
LocalCacheRepository localCacheRepository(Ref ref) {
  return LocalCacheRepository(DatabaseHelper.instance);
}
