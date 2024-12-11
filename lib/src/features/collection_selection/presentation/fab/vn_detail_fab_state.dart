import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vn_detail_fab_state.g.dart';

@riverpod
class VnDetailFabState extends _$VnDetailFabState {
  @override
  bool build(String vnId) => false;

  set show(bool value) => state = value;
}
