import 'dart:convert';
import 'package:eliza_beauty/data/models/user_model.dart';
import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:eliza_beauty/domain/repository/auth_repository.dart';
import 'package:eliza_beauty/domain/use_case/login_usecase.dart';
import 'package:eliza_beauty/data/sources/auth_api_service.dart';
import 'package:eliza_beauty/core/network/chopper_client.dart';
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

      String? errorMessage;
      
      if (errorBody is String) {
        try {
          final decoded = jsonDecode(errorBody);
          if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
            errorMessage = decoded['message'];
          }
        } catch (_) {}
      } else if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
        errorMessage = errorBody['message'];
      }

      throw Exception(errorMessage ?? "Authentication Failed");
    }

    return UserModel.fromJson(response.body!);
  }

  @override
  Future<User> fetchCurrentUser() async {
    final response = await _apiService.getCurrentUser();

    if (!response.isSuccessful) {
      final errorBody = response.error;
      String? errorMessage;
      
      if (errorBody is String) {
        try {
          final decoded = jsonDecode(errorBody);
          if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
            errorMessage = decoded['message'];
          }
        } catch (_) {}
      } else if (errorBody is Map<String, dynamic> && errorBody.containsKey('message')) {
        errorMessage = errorBody['message'];
      }

      throw Exception(errorMessage ?? "Failed to fetch user profile");
    }

    return UserModel.fromJson(response.body!);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final apiService = ref.watch(authApiServiceProvider);
  return AuthRepositoryImpl(apiService);
}

@riverpod
LoginUsecase loginUsecase(Ref ref) {
  return LoginUsecase(ref.watch(authRepositoryProvider));
}
