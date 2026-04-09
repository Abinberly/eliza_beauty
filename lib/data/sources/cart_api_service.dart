import 'package:chopper/chopper.dart';
import 'package:eliza_beauty/core/constants/api_endpoints.dart';

part 'cart_api_service.chopper.dart';

@ChopperApi(baseUrl: ApiEndpoints.cartsBase)
abstract class CartApiService extends ChopperService {
  @GET()
  Future<Response> getCarts({@Query() int limit = 10, @Query() int skip = 0});

  @GET(path: ApiEndpoints.getCart)
  Future<Response> getCart(@Path() int id);

  @GET(path: ApiEndpoints.getUserCarts)
  Future<Response> getUserCarts(@Path() int userId);

  @PUT(path: ApiEndpoints.updateCart)
  Future<Response> updateCart(@Path() int id, @Body() Map<String, dynamic> body);

  @POST(path: ApiEndpoints.addToCart)
  Future<Response> addToCart(@Body() Map<String, dynamic> body);

  @DELETE(path: ApiEndpoints.deleteCart)
  Future<Response> deleteCart(@Path() int id);

  static CartApiService create([ChopperClient? client]) => _$CartApiService(client);
}