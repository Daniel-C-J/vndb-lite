import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_filter_result_controller.g.dart';

@riverpod
class DevSearchController extends _$DevSearchController {
  @override
  String build() {
    return "";
  }

  @override
  set state(String newState) => super.state = newState;
}

@riverpod
class TagSearchController extends _$TagSearchController {
  @override
  String build() {
    return "";
  }

  @override
  set state(String newState) => super.state = newState;
}
