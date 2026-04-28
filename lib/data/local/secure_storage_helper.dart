import 'package:eliza_beauty/domain/repository/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_helper.g.dart';

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

class SecureStorageHelper implements StorageRepository {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userAccountKey = 'user_account_json';
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _themeKey = 'app_theme';

  final FlutterSecureStorage _storage;

  SecureStorageHelper(this._storage);

  // Access Token & Refresh Token
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  // User Data
  Future<void> saveUserAccount(String userJson) async {
    await _storage.write(key: _userAccountKey, value: userJson);
  }

  Future<String?> getUserAccount() async {
    return await _storage.read(key: _userAccountKey);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userAccountKey);
  }

  // Onboarding Status
  @override
  Future<void> saveOnboardingStatus({required bool isComplete}) async {
    await _storage.write(
      key: _onboardingCompleteKey,
      value: isComplete.toString(),
    );
  }

  @override
  Future<bool> getOnboardingStatus() async {
    final status = await _storage.read(key: _onboardingCompleteKey);
    return status == 'true';
  }

  // Theme Data
  Future<void> saveTheme({required String theme}) async {
    await _storage.write(key: _themeKey, value: theme);
  }

  Future<String?> getTheme() async => await _storage.read(key: _themeKey);

  // Clear All Data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
SecureStorageHelper secureStorageHelper(Ref ref) {
  return SecureStorageHelper(ref.watch(secureStorageProvider));
}

@Riverpod(keepAlive: true)
StorageRepository storageRepository(Ref ref) {
  return ref.watch(secureStorageHelperProvider);
}
