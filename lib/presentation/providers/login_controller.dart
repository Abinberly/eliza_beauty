import 'dart:convert';
import 'package:eliza_beauty/core/local/secure_storage_helper.dart';
import 'package:eliza_beauty/data/models/user_model.dart';
import 'package:eliza_beauty/domain/use_case/login_usecase.dart';
import 'package:eliza_beauty/presentation/providers/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<bool?> build() => null;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    print('DEBUG: Attempting login for user: $email ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️');
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
    state = const AsyncValue.loading();
  try {
    await ref.read(secureStorageHelperProvider).clearAll(); 
    
    ref.read(userProfileProvider.notifier).clearUser();

    state = const AsyncValue.data(null);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
  }
  }
}
