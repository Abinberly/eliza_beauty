import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:eliza_beauty/domain/repository/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<User> execute(String email, String password) {
    return _repository.signIn(email, password);
  }
}