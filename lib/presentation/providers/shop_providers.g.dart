// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesHash() => r'77eec094118e826d8b982d23ccd577e7e68404f2';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider =
    AutoDisposeFutureProvider<List<CategoryModel>>.internal(
      categories,
      name: r'categoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = AutoDisposeFutureProviderRef<List<CategoryModel>>;
String _$selectedCategoryHash() => r'd10f526465c43061d441e6c4cd6b09c746b97615';

/// See also [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String>.internal(
      SelectedCategory.new,
      name: r'selectedCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCategory = AutoDisposeNotifier<String>;
String _$productsByCategoryHash() =>
    r'b7a17f83d6b6104a614b3222643c3c022de39a26';

/// See also [ProductsByCategory].
@ProviderFor(ProductsByCategory)
final productsByCategoryProvider =
    AutoDisposeAsyncNotifierProvider<
      ProductsByCategory,
      List<ProductModel>
    >.internal(
      ProductsByCategory.new,
      name: r'productsByCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productsByCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProductsByCategory = AutoDisposeAsyncNotifier<List<ProductModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
