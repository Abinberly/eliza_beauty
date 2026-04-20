import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/data/models/product_model.dart';
import 'package:eliza_beauty/data/sources/product_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'details_provider.g.dart';

@riverpod
Future<ProductModel> productDetails(Ref ref, int id) async {
  final client = ref.watch(chopperClientProvider);
  final service = client.getService<ProductApiService>();
  
  final response = await service.getProductDetails(id);
  
  if (response.isSuccessful && response.body != null) {
    return ProductModel.fromJson(response.body!);
  } else {
    throw Exception("Product not found");
  }
}

@riverpod
Future<List<ProductModel>> similarProducts(Ref ref, String category) async {
  final client = ref.watch(chopperClientProvider);
  final service = client.getService<ProductApiService>();
  
  final response = await service.getProductsByCategory(category, limit: 10);
  
  if (response.isSuccessful && response.body != null && response.body!['products'] != null) {
    final List<dynamic> productsList = response.body!['products'];
    return productsList.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  
  return [];
}