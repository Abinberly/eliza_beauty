import 'package:eliza_beauty/data/models/user_model.dart';
import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:eliza_beauty/domain/repository/auth_repository.dart';
import 'package:eliza_beauty/data/sources/auth_api_service.dart';
import 'package:eliza_beauty/presentation/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<User> signIn(String email, String password) async {
    final response = await _apiService.login({
      'username': email,
      'password': password,
    });

    if (!response.isSuccessful) {
      final errorBody = response.error;

      if (errorBody is Map<String, dynamic> &&
          errorBody.containsKey("message")) {
        throw Exception(errorBody['message'] ?? "Authentication Failed");
      }
    }

    return UserModel.fromJson(response.body!);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiService = ref.watch(authApiProvider);
  return AuthRepositoryImpl(apiService);
}
