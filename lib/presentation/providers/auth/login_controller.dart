import 'dart:convert';
import 'package:eliza_beauty/data/local/secure_storage_helper.dart';
import 'package:eliza_beauty/data/models/user_model.dart';
import 'package:eliza_beauty/data/repositories/auth_repository_impl.dart';
import 'package:eliza_beauty/presentation/providers/auth/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<bool?> build() => null;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard<bool?>(() async {
      final user = await ref
          .read(loginUsecaseProvider)
          .execute(email, password);

      final secureStorage = ref.read(secureStorageHelperProvider);

      await secureStorage.saveTokens(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
      );

      if (user is UserModel) {
        await secureStorage.saveUserAccount(jsonEncode(user.toJson()));
      }

      ref.read(userProfileProvider.notifier).setUser(user);
      return true;
    });
  }

  Future<void> logout() async {
    try {
      state = const AsyncValue.loading();

      await ref.read(secureStorageHelperProvider).clearAll();

      ref.read(userProfileProvider.notifier).clearUser();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      try {
        state = AsyncValue.error(e, st);
      } catch (_) {}
    }
  }
}
