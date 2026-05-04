import '../../../core/network/chopper_client.dart';
import '../../../data/models/product_model.dart';
import '../../../data/sources/product_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'details_provider.g.dart';

@Riverpod(keepAlive: true)
Future<ProductModel> productDetails(Ref ref, int id) async {
  final client = ref.watch(chopperClientProvider);
  final service = client.getService<ProductApiService>();
  
  final response = await service.getProductDetails(id);
  
  if (response.isSuccessful && response.body != null) {
    return ProductModel.fromJson(response.body!);
  } else {
    throw Exception('Product not found');
  }
}

@Riverpod(keepAlive: true)
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