// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productDetailsHash() => r'418930eb4a70a4673b871784103ca1e896dc7f00';

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

/// See also [productDetails].
@ProviderFor(productDetails)
const productDetailsProvider = ProductDetailsFamily();

/// See also [productDetails].
class ProductDetailsFamily extends Family<AsyncValue<ProductModel>> {
  /// See also [productDetails].
  const ProductDetailsFamily();

  /// See also [productDetails].
  ProductDetailsProvider call(int id) {
    return ProductDetailsProvider(id);
  }

  @override
  ProductDetailsProvider getProviderOverride(
    covariant ProductDetailsProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailsProvider';
}

/// See also [productDetails].
class ProductDetailsProvider extends AutoDisposeFutureProvider<ProductModel> {
  /// See also [productDetails].
  ProductDetailsProvider(int id)
    : this._internal(
        (ref) => productDetails(ref as ProductDetailsRef, id),
        from: productDetailsProvider,
        name: r'productDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productDetailsHash,
        dependencies: ProductDetailsFamily._dependencies,
        allTransitiveDependencies:
            ProductDetailsFamily._allTransitiveDependencies,
        id: id,
      );

  ProductDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<ProductModel> Function(ProductDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailsProvider._internal(
        (ref) => create(ref as ProductDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProductModel> createElement() {
    return _ProductDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailsRef on AutoDisposeFutureProviderRef<ProductModel> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ProductDetailsProviderElement
    extends AutoDisposeFutureProviderElement<ProductModel>
    with ProductDetailsRef {
  _ProductDetailsProviderElement(super.provider);

  @override
  int get id => (origin as ProductDetailsProvider).id;
}

String _$similarProductsHash() => r'98da935520786033e1a970ff2238e481053b62a7';

/// See also [similarProducts].
@ProviderFor(similarProducts)
const similarProductsProvider = SimilarProductsFamily();

/// See also [similarProducts].
class SimilarProductsFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [similarProducts].
  const SimilarProductsFamily();

  /// See also [similarProducts].
  SimilarProductsProvider call(String category) {
    return SimilarProductsProvider(category);
  }

  @override
  SimilarProductsProvider getProviderOverride(
    covariant SimilarProductsProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'similarProductsProvider';
}

/// See also [similarProducts].
class SimilarProductsProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [similarProducts].
  SimilarProductsProvider(String category)
    : this._internal(
        (ref) => similarProducts(ref as SimilarProductsRef, category),
        from: similarProductsProvider,
        name: r'similarProductsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$similarProductsHash,
        dependencies: SimilarProductsFamily._dependencies,
        allTransitiveDependencies:
            SimilarProductsFamily._allTransitiveDependencies,
        category: category,
      );

  SimilarProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<ProductModel>> Function(SimilarProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SimilarProductsProvider._internal(
        (ref) => create(ref as SimilarProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _SimilarProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimilarProductsProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SimilarProductsRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _SimilarProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with SimilarProductsRef {
  _SimilarProductsProviderElement(super.provider);

  @override
  String get category => (origin as SimilarProductsProvider).category;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
