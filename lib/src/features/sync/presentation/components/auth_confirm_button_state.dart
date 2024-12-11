import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/util/button_states.dart';

part 'auth_confirm_button_state.g.dart';

@riverpod
class AuthConfirmButtonState extends _$AuthConfirmButtonState {
  @override
  ConfirmButtonState build() {
    return ConfirmButtonState.disabled;
  }

  @override
  set state(ConfirmButtonState newState) => super.state = newState;
}
