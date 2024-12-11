import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dialog_dismissed_state.g.dart';

@Riverpod(keepAlive: true)
class DialogDismissedState extends _$DialogDismissedState {
  @override
  bool build() {
    return true;
  }

  set dismissed(bool value) => state = value;
}
