import 'package:chopper/chopper.dart';
import 'package:eliza_beauty/core/constants/api_endpoints.dart';

part 'auth_api_service.chopper.dart';

@ChopperApi(baseUrl: ApiEndpoints.authBase)
abstract class AuthApiService extends ChopperService {
  static AuthApiService create([ChopperClient? client]) =>
      _$AuthApiService(client);

  @POST(path: ApiEndpoints.login)
  Future<Response<Map<String, dynamic>>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: ApiEndpoints.refresh)
  Future<Response<Map<String, dynamic>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: ApiEndpoints.currentUser)
  Future<Response<Map<String, dynamic>>> getCurrentUser();
}
