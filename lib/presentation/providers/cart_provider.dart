import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/domain/entities/cart_item.dart';
import 'package:eliza_beauty/presentation/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  @override
  Future<List<Cart>> build() async {
    final userAsync = ref.watch(userProfileProvider);
    if (userAsync.value == null) return [];
    
    final service = ref.read(cartApiServiceProvider);
    
    // As per dummyjson structure, hitting /carts/user/{id} will yield users' dummy carts if they exist.
    final response = await service.getUserCarts(userAsync.value!.id);

    if (response.isSuccessful && response.body != null) {
      final data = response.body as Map<String, dynamic>;
      final List cartsJson = data['carts'];
      
      return cartsJson.map(_parseCart).toList();
    } else {
      throw Exception("Failed to fetch carts");
    }
  }

  Cart _parseCart(dynamic json) {
    return Cart(
      id: json['id'],
      total: (json['total'] as num).toDouble(),
      totalQuantity: json['totalQuantity'],
      products: (json['products'] as List).map((p) => CartProduct(
        id: p['id'],
        title: p['title'],
        price: (p['price'] as num).toDouble(),
        quantity: p['quantity'],
        thumbnail: p['thumbnail'],
      )).toList(),
    );
  }

  Future<void> fetchNextPage() async {}

  Future<void> removeItem(int cartId) async {
    final previousState = state.value;
    state = AsyncData(state.value!.where((c) => c.id != cartId).toList());

    try {
      final service = ref.read(cartApiServiceProvider);
      await service.deleteCart(cartId);
      // Failures explicitly ignored so UI reflects changes even over dummy JSON network issues or phantom creations
    } catch (e) {
      state = AsyncData(previousState!);
    }
  }

  Future<void> removeProduct(int cartId, int productId) async {
    final carts = state.value;
    if (carts == null) return;
    
    final cart = carts.firstWhere((c) => c.id == cartId);
    final updatedProductsList = cart.products.where((p) => p.id != productId).toList();
    
    if (updatedProductsList.isEmpty) {
      return removeItem(cartId); 
    }

    final previousState = state.value;
    final updatedCartLocal = _recalculateCart(cart.id, updatedProductsList);
    
    state = AsyncData(carts.map((c) => c.id == cartId ? updatedCartLocal : c).toList());

    try {
      final service = ref.read(cartApiServiceProvider);
      final existingProductsParams = updatedProductsList.map((p) => {
        'id': p.id,
        'quantity': p.quantity,
      }).toList();
      
      await service.updateCart(cartId, {
        'merge': false,
        'products': existingProductsParams,
      });
    } catch (e) {
      state = AsyncData(previousState!);
    }
  }

  Future<void> updateItemQuantity(int cartId, int productId, int quantity) async {
    if (quantity <= 0) {
      return removeProduct(cartId, productId);
    }
    
    final carts = state.value;
    if (carts == null) return;
    
    final previousState = state.value;
    state = AsyncData(carts.map((c) {
      if (c.id == cartId) {
        final products = c.products.map((p) => p.id == productId ? CartProduct(
          id: p.id,
          title: p.title,
          price: p.price,
          quantity: quantity,
          thumbnail: p.thumbnail,
        ) : p).toList();
        
        return _recalculateCart(c.id, products);
      }
      return c;
    }).toList());

    try {
      final service = ref.read(cartApiServiceProvider);
      await service.updateCart(cartId, {
        'merge': true,
        'products': [
          {'id': productId, 'quantity': quantity}
        ],
      });
    } catch (e) {
      state = AsyncData(previousState!);
    }
  }

  Future<void> addItemToCart(int userId, ProductModel product) async {
    final carts = state.value;
    final service = ref.read(cartApiServiceProvider);
    
    final newCartProduct = CartProduct(
      id: product.id,
      title: product.title,
      price: product.price,
      quantity: 1,
      thumbnail: product.thumbnail,
    );

    if (carts != null && carts.isNotEmpty) {
       final cartId = carts.first.id;
       List<CartProduct> locallyUpdated = List.from(carts.first.products);
       
       final locIdx = locallyUpdated.indexWhere((lp) => lp.id == product.id);
       if (locIdx >= 0) {
           locallyUpdated[locIdx] = CartProduct(
               id: locallyUpdated[locIdx].id,
               title: locallyUpdated[locIdx].title,
               price: locallyUpdated[locIdx].price,
               quantity: locallyUpdated[locIdx].quantity + 1,
               thumbnail: locallyUpdated[locIdx].thumbnail,
           );
       } else {
           locallyUpdated.add(newCartProduct);
       }

       final finalCart = _recalculateCart(cartId, locallyUpdated);
       state = AsyncData(carts.map((c) => c.id == cartId ? finalCart : c).toList());

       try {
         await service.updateCart(cartId, {
           'merge': true,
           'products': [{'id': product.id, 'quantity': 1}],
         });
       } catch (e) {
         // Silently ignore 
       }
    } else {
       final randomId = DateTime.now().millisecondsSinceEpoch % 10000;
       final finalCart = _recalculateCart(randomId, [newCartProduct]);
       
       state = AsyncData([finalCart, ...?carts]);

       try {
         final response = await service.addToCart({
           'userId': userId,
           'products': [{'id': product.id, 'quantity': 1}],
         });
         
         if (response.isSuccessful && response.body != null) {
            final apiCart = _parseCart(response.body);
            final updatedCart = Cart(
              id: apiCart.id,
              total: finalCart.total,
              totalQuantity: finalCart.totalQuantity,
              products: finalCart.products,
            );
            state = AsyncData(state.value!.map((c) => c.id == finalCart.id ? updatedCart : c).toList());
         }
       } catch (e) {
         // Silently ignore
       }
    }
  }

  Cart _recalculateCart(int id, List<CartProduct> products) {
    return Cart(
      id: id,
      total: products.fold(0.0, (sum, p) => sum + (p.price * p.quantity)),
      totalQuantity: products.fold(0, (sum, p) => sum + p.quantity),
      products: products,
    );
  }
}