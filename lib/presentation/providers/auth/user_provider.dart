import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:eliza_beauty/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserProfile extends _$UserProfile {
  @override
  FutureOr<User?> build() => null;

  void setUser(User user) {
    state = AsyncValue.data(user);
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
Future<User> liveUserProfile(LiveUserProfileRef ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.fetchCurrentUser();
}

