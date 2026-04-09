class ApiEndpoints {
  // Base URL
  static const String baseUrl = "https://dummyjson.com";

  // Auth Endpoints
  static const String authBase = '/auth';
  static const String login = '/login';
  static const String refresh = '/refresh';
  static const String currentUser = '/me';

  // Product Endpoints
  static const String productsBase = '/products';
  static const String categories = '/categories';
  static const String categoryBySlug = '/category/{slug}';
  static const String productDetails = '/{id}';
  static const String searchProducts = '/search';

  // Carts Endpoints
  static const String cartsBase = '/carts';
  static const String getCart = '/{id}';
  static const String getUserCarts = '/user/{userId}';
  static const String updateCart = '/{id}';
  static const String addToCart = '/add';
  static const String deleteCart = '/{id}';
}
