import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
 
part 'secure_storage_helper.g.dart';
 
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}
 
class SecureStorageHelper {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userAccountKey = 'user_account_json';
  static const _onboardingCompleteKey = 'onboarding_complete';

  final FlutterSecureStorage _storage;
 
  SecureStorageHelper(this._storage);
 
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }
  Future<String?> getAccessToken() async => await _storage.read(key: _accessTokenKey);
  
  Future<String?> getRefreshToken() async => await _storage.read(key: _refreshTokenKey);

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

  Future<void> saveOnboardingStatus({required bool isComplete}) async {
    await _storage.write(key: _onboardingCompleteKey, value: isComplete.toString());
  }

  Future<bool> getOnboardingStatus() async {
    final status = await _storage.read(key: _onboardingCompleteKey);
    return status == 'true';
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      print('DEBUG: Secure Storage cleared successfully');
    } catch (e) {
      print('DEBUG: Error clearing Secure Storage: $e');
      rethrow;
    }
  }
}
 
@Riverpod(keepAlive: true)
SecureStorageHelper secureStorageHelper(Ref ref) {
  return SecureStorageHelper(ref.watch(secureStorageProvider));
}