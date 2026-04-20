import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_selection_provider.g.dart';

@riverpod
class SelectedImageIndex extends _$SelectedImageIndex {

@override
 int build() => 0;

 void select(int index) => state = index;
}