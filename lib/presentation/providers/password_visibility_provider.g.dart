// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_visibility_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passwordVisibilityHash() =>
    r'98fc50dece498faa6bf1080ed4854f95b874754c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PasswordVisibility extends BuildlessAutoDisposeNotifier<bool> {
  late final String fieldId;

  bool build(String fieldId);
}

/// See also [PasswordVisibility].
@ProviderFor(PasswordVisibility)
const passwordVisibilityProvider = PasswordVisibilityFamily();

/// See also [PasswordVisibility].
class PasswordVisibilityFamily extends Family<bool> {
  /// See also [PasswordVisibility].
  const PasswordVisibilityFamily();

  /// See also [PasswordVisibility].
  PasswordVisibilityProvider call(String fieldId) {
    return PasswordVisibilityProvider(fieldId);
  }

  @override
  PasswordVisibilityProvider getProviderOverride(
    covariant PasswordVisibilityProvider provider,
  ) {
    return call(provider.fieldId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'passwordVisibilityProvider';
}

/// See also [PasswordVisibility].
class PasswordVisibilityProvider
    extends AutoDisposeNotifierProviderImpl<PasswordVisibility, bool> {
  /// See also [PasswordVisibility].
  PasswordVisibilityProvider(String fieldId)
    : this._internal(
        () => PasswordVisibility()..fieldId = fieldId,
        from: passwordVisibilityProvider,
        name: r'passwordVisibilityProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$passwordVisibilityHash,
        dependencies: PasswordVisibilityFamily._dependencies,
        allTransitiveDependencies:
            PasswordVisibilityFamily._allTransitiveDependencies,
        fieldId: fieldId,
      );

  PasswordVisibilityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.fieldId,
  }) : super.internal();

  final String fieldId;

  @override
  bool runNotifierBuild(covariant PasswordVisibility notifier) {
    return notifier.build(fieldId);
  }

  @override
  Override overrideWith(PasswordVisibility Function() create) {
    return ProviderOverride(
      origin: this,
      override: PasswordVisibilityProvider._internal(
        () => create()..fieldId = fieldId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        fieldId: fieldId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PasswordVisibility, bool> createElement() {
    return _PasswordVisibilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PasswordVisibilityProvider && other.fieldId == fieldId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, fieldId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PasswordVisibilityRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `fieldId` of this provider.
  String get fieldId;
}

class _PasswordVisibilityProviderElement
    extends AutoDisposeNotifierProviderElement<PasswordVisibility, bool>
    with PasswordVisibilityRef {
  _PasswordVisibilityProviderElement(super.provider);

  @override
  String get fieldId => (origin as PasswordVisibilityProvider).fieldId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
