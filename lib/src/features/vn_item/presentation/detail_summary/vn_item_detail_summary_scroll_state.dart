import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vn_item_detail_summary_scroll_state.g.dart';

@riverpod
class VnItemSummaryScrollState extends _$VnItemSummaryScrollState {
  @override
  bool build() {
    return false;
  }

  set isScrolling(bool value) => state = value;
}
