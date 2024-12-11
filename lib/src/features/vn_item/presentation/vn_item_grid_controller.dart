import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vn_item_grid_controller.g.dart';

@Riverpod(keepAlive: true)
class VnItemGridCoverCensorState extends _$VnItemGridCoverCensorState {
  @override
  bool build(String vnId) {
    return false;
  }

  set censor(bool value) => state = value;
}

@Riverpod(keepAlive: true)
class VnItemGridCoverSizeState extends _$VnItemGridCoverSizeState {
  @override
  double build(String vnUrl) {
    return 100; // Default value.
  }

  set size(double size) => state = size;
}

@Riverpod(keepAlive: true)
class VnItemGridWidgetState extends _$VnItemGridWidgetState {
  @override
  bool build(String vnId) {
    return false;
  }

  set show(bool value) => state = value;
}

@riverpod
class VnItemGridAlmostLongPressedState extends _$VnItemGridAlmostLongPressedState {
  @override
  String build() {
    return "";
  }

  set vnId(String value) => state = value;
}
