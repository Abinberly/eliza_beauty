class CartProduct {

  CartProduct({required this.id, required this.title, required this.price, required this.quantity, required this.thumbnail});
  final int id;
  final String title;
  final double price;
  final int quantity;
  final String thumbnail;
}

class Cart {

  Cart({required this.id, required this.products, required this.total, required this.totalQuantity});
  final int id;
  final List<CartProduct> products;
  final double total;
  final int totalQuantity;
}