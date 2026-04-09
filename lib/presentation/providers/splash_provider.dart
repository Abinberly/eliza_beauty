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
    print('DEBUG: Notifier build started');
    final storage = ref.read(secureStorageHelperProvider);

    final token = await storage.getAccessToken();
    if (token == null || token.isEmpty) {
      print('DEBUG: No token found. Navigating to login.');
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
        print('DEBUG: User state restored from local storage.');
      } catch (e) {
        print('DEBUG: Error restoring local user: $e');
      }
    }

    _validateUserInBackground();

    print('DEBUG: Persistent session found. Navigating to home.');
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
        print('DEBUG: Background user validation successful.');
      }
    } catch (e) {
      print('DEBUG: Background validation failed (usually network issues): $e');
    }
  }
}

// @riverpod
// class SplashNotifier extends _$SplashNotifier {
//   @override
//   FutureOr<String?> build() async {
//     print('DEBUG: Notifier build started');
//     final storage = ref.read(secureStorageHelperProvider);
//     final useCase = InitializationUseCase(storage);
//     String result = await useCase();
//     print('DEBUG: UseCase returned: $result');

//     if (result == AppRoutes.home) {
//       final token = await storage.getAccessToken();
//       if (token == null || token.isEmpty) {
//         return AppRoutes.login;
//       }

//       final hasInternet = await NetworkInfo.isConnected();
//       if (!hasInternet) {
//         print('DEBUG: No internet at launch, bypassing strict auth check temporarily.');
//         final userJsonString = await storage.getUserAccount();
//         if (userJsonString != null && userJsonString.isNotEmpty) {
//           try {
//             final userJson = jsonDecode(userJsonString);
//             final user = UserModel.fromJson(userJson);
            
//             final restorableUser = user.copyWith(
//               accessToken: token,
//               refreshToken: await storage.getRefreshToken(),
//             );
//             ref.read(userProfileProvider.notifier).setUser(restorableUser);
//           } catch (e) {
//             print('DEBUG: Error decoding user account: $e');
//             return AppRoutes.login;
//           }
//         }
//         return result;
//       }

//       try {
//         final client = ref.read(chopperClientProvider);
//         final authService = client.getService<AuthApiService>();
//         final response = await authService.getCurrentUser();

//         if (response.isSuccessful && response.body != null) {
//           final dynamic rawBody = response.body;
//           Map<String, dynamic> data;
          
//           if (rawBody is String) {
//             data = jsonDecode(rawBody);
//           } else {
//             data = rawBody as Map<String, dynamic>;
//           }

//           final user = UserModel.fromJson(data);
          
//           final restorableUser = user.copyWith(
//               accessToken: await storage.getAccessToken(),
//               refreshToken: await storage.getRefreshToken(),
//           );
          
//           ref.read(userProfileProvider.notifier).setUser(restorableUser);
//         } else {
//           print('DEBUG: /auth/me failed with status ${response.statusCode}');
//           result = AppRoutes.login;
//         }
//       } catch (e) {
//         print('DEBUG: API Error checking currentUser: $e');
//         result = AppRoutes.login;
//       }
//     }

//     return result;
//   }
// }
