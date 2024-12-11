import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/util/button_states.dart';

part 'footer_button_state.g.dart';

@riverpod
class VnConfirmButtonState extends _$VnConfirmButtonState {
  @override
  ConfirmButtonState build() {
    return ConfirmButtonState.normal;
  }

  @override
  set state(ConfirmButtonState newState) => super.state = newState;
}
