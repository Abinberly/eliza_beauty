import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserProfile extends _$UserProfile {
  @override
  FutureOr<User?> build() => null;

  void setUser(User user) {
   if (user != null) {
      print('DEBUG: Storing User in State -> ID: ${user.id}, Name: ${user.firstName}');
      state = AsyncValue.data(user);
    } else {
      print('DEBUG: setUser was called with a NULL user object!');
    }
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }
}
