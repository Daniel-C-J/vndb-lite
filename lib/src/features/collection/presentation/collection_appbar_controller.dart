import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collection_appbar_controller.g.dart';

@riverpod
class ShowSearchTextField extends _$ShowSearchTextField {
  @override
  bool build() {
    return false;
  }

  @override
  set state(bool newState) => super.state = newState;

  void resetState() => state = false;
}

// final showSearchTextFieldProvider = StateProvider<bool>((ref) {
//   return false;
// });
