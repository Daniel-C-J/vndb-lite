import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_token_field_controller.g.dart';

@Riverpod(keepAlive: true)
class ShowAuthTokenFieldState extends _$ShowAuthTokenFieldState {
  @override
  bool build() {
    return true;
  }

  set show(bool value) => state = value;
}

@riverpod
class AuthTokenFieldController extends _$AuthTokenFieldController {
  @override
  String build() {
    return "";
  }

  set value(String value) => state = value;
}

@Riverpod(keepAlive: true)
class AuthTokenFieldServerErrorController extends _$AuthTokenFieldServerErrorController {
  @override
  String build() {
    return "";
  }

  set error(String value) => state = value;
}
