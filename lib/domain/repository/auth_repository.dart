import 'package:eliza_beauty/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> fetchCurrentUser();
}