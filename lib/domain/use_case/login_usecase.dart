import '../entities/user.dart';
import '../repository/auth_repository.dart';

class LoginUsecase {

  LoginUsecase(this._repository);
  final AuthRepository _repository;

  Future<User> execute(String email, String password) {
    return _repository.signIn(email, password);
  }
}