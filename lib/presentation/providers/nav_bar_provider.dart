import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nav_bar_provider.g.dart';

@riverpod
class NavBarIndex extends _$NavBarIndex {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}