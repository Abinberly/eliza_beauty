import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/wishlist_model.dart';
import '../../../data/repositories/i_wishlist_repository.dart';
import '../../../data/repositories/wishlist_repository_impl.dart';
import '../auth/user_provider.dart';

part 'wishlist_provider.g.dart';

@Riverpod(keepAlive: true)
IWishlistRepository wishlistRepository(Ref ref) {
  return WishlistRepositoryImpl();
}

@Riverpod(keepAlive: true)
class WishlistNotifier extends _$WishlistNotifier {
  
  @override
  FutureOr<List<WishlistItem>> build() async {
    final user = ref.watch(userProfileProvider).value;
    if (user == null) return [];
    
    final repository = ref.watch(wishlistRepositoryProvider);
    return repository.getWishlist(user.id.toString());
  }

  Future<void> toggleItem(ProductInfo product) async {
    final user = ref.read(userProfileProvider).value;
    if (user == null) return;

    final repository = ref.read(wishlistRepositoryProvider);
    final userId = user.id.toString();
    
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = state.valueOrNull ?? [];
      final isExist = items.any((item) => item.productId == product.id);

      if (isExist) {
        await repository.remove(userId, product.id);
      } else {
        await repository.add(userId, product);
      }
      
      return repository.getWishlist(userId);
    });
  }

  Future<void> clearAll() async {
    final user = ref.read(userProfileProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(wishlistRepositoryProvider).clear(user.id.toString());
      return [];
    });
  }
}

@riverpod
bool isProductWishlisted(Ref ref, int productId) {
  final wishlist = ref.watch(wishlistNotifierProvider).valueOrNull ?? [];
  return wishlist.any((item) => item.productId == productId);
}