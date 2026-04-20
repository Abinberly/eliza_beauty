import 'package:chopper/chopper.dart';
import 'package:eliza_beauty/data/local/secure_storage_helper.dart';
import 'package:eliza_beauty/core/constants/api_endpoints.dart';
import 'package:eliza_beauty/data/sources/auth_api_service.dart';
import 'package:eliza_beauty/data/sources/cart_api_service.dart';
import 'package:eliza_beauty/data/sources/product_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chopper_client.g.dart';

@riverpod
ChopperClient refreshChopperClient(Ref ref) {
  return ChopperClient(
    baseUrl: Uri.parse(ApiEndpoints.baseUrl),
    services: [AuthApiService.create()],
    converter: const JsonConverter(),
    interceptors: [HttpLoggingInterceptor()],
  );
}

@Riverpod(keepAlive: true)
ChopperClient chopperClient(Ref ref) {
  final storage = ref.watch(secureStorageHelperProvider);

  return ChopperClient(
    baseUrl: Uri.parse(ApiEndpoints.baseUrl),
    services: [AuthApiService.create(), ProductApiService.create(), CartApiService.create()],
    converter: const JsonConverter(),
    interceptors: [HttpLoggingInterceptor(), AuthInterceptor(storage)],

    authenticator: MyAuthenticator(ref),
  );
}

class AuthInterceptor implements Interceptor {
  final SecureStorageHelper storage;

  AuthInterceptor(this.storage);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    final token = await storage.getAccessToken();
    final modifiedRequest = token != null
        ? applyHeader(request, 'Authorization', 'Bearer $token')
        : request;

    return chain.proceed(modifiedRequest);
  }
}

@riverpod
AuthApiService authApiService(Ref ref) {
  return ref.watch(chopperClientProvider).getService<AuthApiService>();
}

@riverpod
CartApiService cartApiService(Ref ref) {
  return ref.watch(chopperClientProvider).getService<CartApiService>();
}

@riverpod
ProductApiService productApiService(Ref ref) {
  return ref.watch(chopperClientProvider).getService<ProductApiService>();
}

class MyAuthenticator extends Authenticator {
  final Ref ref;
  MyAuthenticator(this.ref);

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode != 401) return null;

    final storage = ref.read(secureStorageHelperProvider);
    final refreshToken = await storage.getRefreshToken();

    if (refreshToken == null) return null;

    try {
      final refreshClient = ref.read(refreshChopperClientProvider);
      final authService = refreshClient.getService<AuthApiService>();

      final refreshResponse = await authService.refreshToken({
        'refreshToken': refreshToken,
        'expiresInMins': 30,
      });

      if (refreshResponse.isSuccessful && refreshResponse.body != null) {
        final data = refreshResponse.body!;
        final newAccess = data['accessToken'] as String;
        final newRefresh = data['refreshToken'] as String;

        await storage.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );

        return applyHeader(request, 'Authorization', 'Bearer $newAccess');
      } else {

      }
    } catch (e) {
      await storage.deleteTokens();
    }

    return null;
  }
}
