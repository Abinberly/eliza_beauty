// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CartApiService extends CartApiService {
  _$CartApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CartApiService;

  @override
  Future<Response<dynamic>> getCarts({int limit = 10, int skip = 0}) {
    final Uri $url = Uri.parse('/carts');
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
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCart(int id) {
    final Uri $url = Uri.parse('/carts/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUserCarts(int userId) {
    final Uri $url = Uri.parse('/carts/user/${userId}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateCart(int id, Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/carts/${id}');
    final $body = body;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addToCart(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/carts/add');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteCart(int id) {
    final Uri $url = Uri.parse('/carts/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
