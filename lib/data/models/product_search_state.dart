// domain/models/product_search_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'product_model.dart';

part 'product_search_state.freezed.dart';

@freezed
class ProductSearchState with _$ProductSearchState {
  const factory ProductSearchState({
    @Default([]) List<ProductModel> products,
    @Default('') String query,
    @Default(0) int skip,
    @Default(10) int limit,
    @Default(0) int total,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadMore,
    @Default('title') String sortBy,
    @Default('asc') String order,
    String? selectedCategory,
  }) = _ProductSearchState;

  const ProductSearchState._();
  bool get hasReachedMax => products.length >= total && total != 0;
}