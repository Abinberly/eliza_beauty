import 'package:chopper/chopper.dart';
import 'package:eliza_beauty/core/constants/api_endpoints.dart';

part 'product_api_service.chopper.dart';

@ChopperApi(baseUrl: ApiEndpoints.productsBase)
abstract class ProductApiService extends ChopperService {
  static ProductApiService create([ChopperClient? client]) =>
      _$ProductApiService(client);

  @GET(path: ApiEndpoints.categories)
  Future<Response<List<dynamic>>> getCategories();

  @GET(path: ApiEndpoints.categoryBySlug)
  Future<Response<Map<String, dynamic>>> getProductsByCategory(
    @Path('slug') String slug, {
    @Query('limit') int limit = 10,
    @Query('skip') int skip = 0,
  });

  @GET(path: ApiEndpoints.productDetails)
  Future<Response<Map<String, dynamic>>> getProductDetails(@Path('id') int id);

  @GET(path: ApiEndpoints.searchProducts)
  Future<Response> searchProducts({
    @Query('q') required String query,
    @Query('limit') int limit = 10,
    @Query('skip') int skip = 0,
    @Query('sortBy') String? sortBy,
    @Query('order') String? order, // 'asc' or 'desc'
  });
}
