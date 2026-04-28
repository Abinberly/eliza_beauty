import 'dart:developer';

import 'package:eliza_beauty/domain/entities/user.dart';
import 'package:eliza_beauty/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Fetches live user profile from API.
/// Falls back to cached userProfile on failure (offline).
@riverpod
Future<User?> liveUserProfile(Ref ref) async {
  try {
    final repository = ref.watch(authRepositoryProvider);
    return await repository.fetchCurrentUser();
  } catch (e) {
    log('Live profile fetch failed (offline?), using cached: $e', name: 'UserProvider');
    // Return the locally cached user instead of throwing
    return ref.read(userProfileProvider).value;
  }
}
