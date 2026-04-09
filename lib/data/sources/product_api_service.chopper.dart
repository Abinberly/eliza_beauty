// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProductApiService extends ProductApiService {
  _$ProductApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProductApiService;

  @override
  Future<Response<List<dynamic>>> getCategories() {
    final Uri $url = Uri.parse('/products/categories');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<dynamic>, List<dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getProductsByCategory(
    String slug, {
    int limit = 10,
    int skip = 0,
  }) {
    final Uri $url = Uri.parse('/products/category/${slug}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'limit': limit,
      'skip': skip,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> getProductDetails(int id) {
    final Uri $url = Uri.parse('/products/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<dynamic>> searchProducts({
    required String query,
    int limit = 10,
    int skip = 0,
    String? sortBy,
    String? order,
  }) {
    final Uri $url = Uri.parse('/products/search');
    final Map<String, dynamic> $params = <String, dynamic>{
      'q': query,
      'limit': limit,
      'skip': skip,
      'sortBy': sortBy,
      'order': order,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
