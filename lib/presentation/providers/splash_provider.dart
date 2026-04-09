import 'dart:convert';
import 'package:eliza_beauty/core/local/secure_storage_helper.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/data/models/user_model.dart';
import 'package:eliza_beauty/data/sources/auth_api_service.dart';
import 'package:eliza_beauty/presentation/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  FutureOr<String?> build() async {
    final storage = ref.read(secureStorageHelperProvider);

    await Future.delayed(const Duration(seconds: 3));

    final token = await storage.getAccessToken();
    if (token == null || token.isEmpty) {
      return AppRoutes.login;
    }

    final userJsonString = await storage.getUserAccount();
    if (userJsonString != null && userJsonString.isNotEmpty) {
      try {
        final userJson = jsonDecode(userJsonString);
        final user = UserModel.fromJson(userJson);
        
        final restorableUser = user.copyWith(
          accessToken: token,
          refreshToken: await storage.getRefreshToken(),
        );
        
        ref.read(userProfileProvider.notifier).setUser(restorableUser);
      } catch (e) {
      }
    }

    _validateUserInBackground();

    return AppRoutes.home;
  }

  Future<void> _validateUserInBackground() async {
    try {
      final client = ref.read(chopperClientProvider);
      final authService = client.getService<AuthApiService>();
      final response = await authService.getCurrentUser();

      if (response.isSuccessful && response.body != null) {
        final user = UserModel.fromJson(response.body as Map<String, dynamic>);
        ref.read(userProfileProvider.notifier).setUser(user);
      }
    } catch (e) {
    }
  }
}
