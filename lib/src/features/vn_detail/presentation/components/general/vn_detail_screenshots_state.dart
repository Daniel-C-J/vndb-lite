import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vn_detail_screenshots_state.g.dart';

@riverpod
class VnDetailScreenshotState extends _$VnDetailScreenshotState {
  @override
  bool build() {
    return false;
  }

  set click(bool value) => state = value;
}
