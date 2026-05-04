import '../models/wishlist_model.dart';

abstract class IWishlistRepository {
  Future<List<WishlistItem>> getWishlist(String userId);
  Future<void> add(String userId, ProductInfo product);
  Future<void> remove(String userId, int productId);
  Future<void> clear(String userId);
}