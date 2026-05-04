import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/wishlist_model.dart';
import 'database_helper.dart';

/// Database service for wishlist operations
class WishlistDatabase {
  static const String _wishlistTable = 'wishlist';
  static const int _dbVersion = 4; // Incremented for wishlist table

  /// Create wishlist table
  static Future<void> onCreate(Database db) async {
    await db.execute('''
      CREATE TABLE $_wishlistTable (
        id TEXT PRIMARY KEY,
        product_id INTEGER NOT NULL,
        user_id TEXT NOT NULL,
        added_at TEXT NOT NULL,
        product_info TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('''
      CREATE INDEX idx_wishlist_user_id ON $_wishlistTable (user_id)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_wishlist_product_id ON $_wishlistTable (product_id)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_wishlist_added_at ON $_wishlistTable (added_at)
    ''');
  }

  /// Upgrade database for wishlist table
  static Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < _dbVersion) {
      await onCreate(db);
    }
  }

  /// Add item to wishlist
  static Future<String> addToWishlist({
    required int productId,
    required String userId,
    required ProductInfo product,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final id = '${userId}_${productId}_${DateTime.now().millisecondsSinceEpoch}';
    
    await db.insert(
      _wishlistTable,
      {
        'id': id,
        'product_id': productId,
        'user_id': userId,
        'added_at': DateTime.now().toIso8601String(),
        'product_info': jsonEncode(product.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return id;
  }

  /// Remove item from wishlist
  static Future<int> removeFromWishlist({
    required String userId,
    required int productId,
  }) async {
    final db = await DatabaseHelper.instance.database;
    
    return await db.delete(
      _wishlistTable,
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  /// Remove item from wishlist by ID
  static Future<int> removeFromWishlistById(String wishlistId) async {
    final db = await DatabaseHelper.instance.database;
    
    return await db.delete(
      _wishlistTable,
      where: 'id = ?',
      whereArgs: [wishlistId],
    );
  }

  /// Get all wishlist items for a user
  static Future<List<WishlistItem>> getWishlistItems(String userId) async {
    final db = await DatabaseHelper.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _wishlistTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'added_at DESC',
    );
    
    return List.generate(maps.length, (i) {
      final productJson = jsonDecode(maps[i]['product_info'] as String);
      final product = ProductInfo.fromJson(productJson as Map<String, dynamic>);
      
      return WishlistItem(
        id: maps[i]['id'] as String,
        productId: maps[i]['product_id'] as int,
        userId: maps[i]['user_id'] as String,
        addedAt: DateTime.parse(maps[i]['added_at'] as String),
        product: product,
      );
    });
  }

  /// Check if product is in user's wishlist
  static Future<bool> isProductWishlisted({
    required String userId,
    required int productId,
  }) async {
    final db = await DatabaseHelper.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _wishlistTable,
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
      limit: 1,
    );
    
    return maps.isNotEmpty;
  }

  /// Get wishlist item by user and product
  static Future<WishlistItem?> getWishlistItem({
    required String userId,
    required int productId,
  }) async {
    final db = await DatabaseHelper.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _wishlistTable,
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    
    final productJson = jsonDecode(maps[0]['product_info'] as String);
    final product = ProductInfo.fromJson(productJson as Map<String, dynamic>);
    
    return WishlistItem(
      id: maps[0]['id'] as String,
      productId: maps[0]['product_id'] as int,
      userId: maps[0]['user_id'] as String,
      addedAt: DateTime.parse(maps[0]['added_at'] as String),
      product: product,
    );
  }

  /// Get wishlist count for a user
  static Future<int> getWishlistCount(String userId) async {
    final db = await DatabaseHelper.instance.database;
    
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_wishlistTable WHERE user_id = ?',
      [userId],
    );
    
    return result.first['count'] as int;
  }

  /// Clear all wishlist items for a user
  static Future<int> clearWishlist(String userId) async {
    final db = await DatabaseHelper.instance.database;
    
    return await db.delete(
      _wishlistTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Get recently added wishlist items (limit)
  static Future<List<WishlistItem>> getRecentWishlistItems({
    required String userId,
    int limit = 5,
  }) async {
    final db = await DatabaseHelper.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _wishlistTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'added_at DESC',
      limit: limit,
    );
    
    return List.generate(maps.length, (i) {
      final productJson = jsonDecode(maps[i]['product_info'] as String);
      final product = ProductInfo.fromJson(productJson as Map<String, dynamic>);
      
      return WishlistItem(
        id: maps[i]['id'] as String,
        productId: maps[i]['product_id'] as int,
        userId: maps[i]['user_id'] as String,
        addedAt: DateTime.parse(maps[i]['added_at'] as String),
        product: product,
      );
    });
  }

  /// Search wishlist items by product name
  static Future<List<WishlistItem>> searchWishlistItems({
    required String userId,
    required String query,
  }) async {
    final db = await DatabaseHelper.instance.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _wishlistTable,
      where: 'user_id = ? AND product_info LIKE ?',
      whereArgs: [userId, '%$query%'],
      orderBy: 'added_at DESC',
    );
    
    return List.generate(maps.length, (i) {
      final productJson = jsonDecode(maps[i]['product_info'] as String);
      final product = ProductInfo.fromJson(productJson as Map<String, dynamic>);
      
      return WishlistItem(
        id: maps[i]['id'] as String,
        productId: maps[i]['product_id'] as int,
        userId: maps[i]['user_id'] as String,
        addedAt: DateTime.parse(maps[i]['added_at'] as String),
        product: product,
      );
    });
  }
}
