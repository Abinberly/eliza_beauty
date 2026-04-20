import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eliza_beauty/data/local/secure_storage_helper.dart';
import 'package:eliza_beauty/core/router/app_routes.dart';
import 'package:eliza_beauty/core/network/chopper_client.dart';
import 'package:eliza_beauty/data/models/user_model.dart';
import 'package:eliza_beauty/data/sources/auth_api_service.dart';
import 'package:eliza_beauty/presentation/providers/auth/user_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  FutureOr<String?> build() async {
    final storage = ref.read(secureStorageHelperProvider);
    await Future.delayed(const Duration(seconds: 3));

    // Detect fresh install (handles iOS Keychain persistence after uninstall)
    await _handleFreshInstall(storage);

    // 1. Check onboarding status
    final onboardingDone = await storage.getOnboardingStatus();
    if (!onboardingDone) {
      return AppRoutes.onboarding;
    }

    // 2. Check authentication token
    final token = await storage.getAccessToken();
    if (token == null || token.isEmpty) {
      return AppRoutes.login;
    }

    // 3. Restore user session
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
        log('Failed to restore user session: $e', name: 'SplashProvider');
      }
    }

    _validateUserInBackground();

    return AppRoutes.home;
  }

  /// Detects a fresh install by checking for a file marker in the app's
  /// documents directory. On iOS, this directory is wiped on uninstall
  /// while the Keychain (used by flutter_secure_storage) persists.
  /// If the marker is missing, we clear all stale Keychain data.
  Future<void> _handleFreshInstall(SecureStorageHelper storage) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final markerFile = File('${dir.path}/.eliza_installed');

      if (!markerFile.existsSync()) {
        // Fresh install or reinstall — wipe stale Keychain data
        log('Fresh install detected — clearing stale secure storage', name: 'SplashProvider');
        await storage.clearAll();
        // Create the marker so subsequent launches skip this
        await markerFile.create();
      }
    } catch (e) {
      log('Install detection failed: $e', name: 'SplashProvider');
    }
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
      log('Background user validation failed: $e', name: 'SplashProvider');
    }
  }
}

