// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveUserProfileHash() => r'8873e7e3a59ab7ff16b3c5977915461ba0c5d2bc';

/// See also [liveUserProfile].
@ProviderFor(liveUserProfile)
final liveUserProfileProvider = AutoDisposeFutureProvider<User>.internal(
  liveUserProfile,
  name: r'liveUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LiveUserProfileRef = AutoDisposeFutureProviderRef<User>;
String _$userProfileHash() => r'4051bba17f4529f24a12c2238e63bd3195d0ba2a';

/// See also [UserProfile].
@ProviderFor(UserProfile)
final userProfileProvider = AsyncNotifierProvider<UserProfile, User?>.internal(
  UserProfile.new,
  name: r'userProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserProfile = AsyncNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
