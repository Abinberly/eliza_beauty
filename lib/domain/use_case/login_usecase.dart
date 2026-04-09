import 'package:eliza_beauty/data/repositories/auth_repository_impl.dart';
import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:eliza_beauty/domain/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_usecase.g.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<User> execute(String email, String password) {
    return _repository.signIn(email, password);
  }
}

@riverpod
LoginUsecase loginUsecase(Ref ref) {
  return LoginUsecase(ref.watch(authRepositoryProvider));
}