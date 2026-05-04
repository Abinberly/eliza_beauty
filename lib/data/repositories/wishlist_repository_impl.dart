import '../local/wishlist_database.dart';
import '../models/wishlist_model.dart';
import 'i_wishlist_repository.dart';

class WishlistRepositoryImpl implements IWishlistRepository {
  @override
  Future<List<WishlistItem>> getWishlist(String userId) async {
    return await WishlistDatabase.getWishlistItems(userId);
  }

  @override
  Future<void> add(String userId, ProductInfo product) async {
    await WishlistDatabase.addToWishlist(
      userId: userId, 
      productId: product.id, 
      product: product
    );
  }

  @override
  Future<void> remove(String userId, int productId) async {
    await WishlistDatabase.removeFromWishlist(
      userId: userId, 
      productId: productId
    );
  }

  @override
  Future<void> clear(String userId) async {
    await WishlistDatabase.clearWishlist(userId);
  }
}