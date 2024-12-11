import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/features/sync/presentation/auth_screen_controller.dart';
import 'package:vndb_lite/src/features/sync/presentation/components/auth_confirm_button_state.dart';
import 'package:vndb_lite/src/features/sync/presentation/components/auth_token_field_controller.dart';
import 'package:vndb_lite/src/features/sync/presentation/components/auth_token_validator.dart';
import 'package:vndb_lite/src/util/button_states.dart';

class AuthenticationField extends ConsumerStatefulWidget {
  const AuthenticationField({super.key});

  @override
  ConsumerState<AuthenticationField> createState() => _AuthenticationFieldState();
}

class _AuthenticationFieldState extends ConsumerState<AuthenticationField> {
  late final TextEditingController _authFieldController;

  @override
  void initState() {
    super.initState();
    _authFieldController = TextEditingController();

    // Hide text field and confirm button if already authenticated.
    final uId = ref.read(authScreenControllerProvider);

    if (uId != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ref.read(showAuthTokenFieldStateProvider.notifier).show = false;
      });
    }
  }

  @override
  void dispose() {
    _authFieldController.dispose();
    super.dispose();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool _tokenIsValid(String token) {
    return AuthTokenValidator().isValid(token);
  }

  String? get _errorText {
    final token = _authFieldController.value.text;
    final serverErr = ref.read(authTokenFieldServerErrorControllerProvider);

    if (token.isEmpty) return null; // Ignore if empty.

    if (serverErr.isNotEmpty) return serverErr; // Server-side
    if (!_tokenIsValid(token)) return 'Invalid Token.'; // Client-side
    return null;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _validate(String? token) {
    if (!mounted) return;
    final serverErr = ref.read(authTokenFieldServerErrorControllerProvider).isNotEmpty;

    final errorIsNotEmpty = (_errorText ?? '').isNotEmpty;
    final tokenIsEmpty = (token ?? '').isEmpty;

    // Resetting the server error text, if user is changing the token.
    if (serverErr) {
      ref.read(authTokenFieldServerErrorControllerProvider.notifier).error = "";
    }

    // If there is an error or token is empty.
    if (errorIsNotEmpty || tokenIsEmpty || serverErr) {
      ref.read(authConfirmButtonStateProvider.notifier).state = ConfirmButtonState.disabled;
      return;
    }

    ref.read(authConfirmButtonStateProvider.notifier).state = ConfirmButtonState.normal;
    ref.read(authTokenFieldControllerProvider.notifier).value = token ?? "";
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final uId = ref.watch(authScreenControllerProvider);
    final showAuthField = ref.watch(showAuthTokenFieldStateProvider);
    final buttonState = ref.watch(authConfirmButtonStateProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: App.themeColor.tertiary.withOpacity(0.4), blurRadius: 3),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            App.themeColor.primary.withAlpha(220),
            App.themeColor.primary.withAlpha(140),
          ],
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (showAuthField)
              ? null
              : () {
                  // Show both authField and confirm button.
                  ref.read(showAuthTokenFieldStateProvider.notifier).show = true;
                },
          child: Container(
            width: MediaQuery.sizeOf(context).width * (0.75),
            padding: EdgeInsets.only(
              top: responsiveUI.own(0.035),
              right: responsiveUI.own(0.045),
              left: responsiveUI.own(0.045),
            ),
            // This logic is connected with the initState of this class above.
            child: (!showAuthField && uId != null)
                ? Padding(
                    padding: EdgeInsets.only(bottom: responsiveUI.own(0.035)),
                    child: Wrap(
                      children: [
                        ShadowText("Hey there "),
                        ShadowText(uId.username, color: App.themeColor.secondary),
                        ShadowText(". "),
                        ShadowText("Tap me to change your token :D"),
                      ],
                    ),
                  )

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Text input
                : ValueListenableBuilder(
                    valueListenable: _authFieldController,
                    builder: (context, TextEditingValue value, __) {
                      return Padding(
                        padding: EdgeInsets.only(
                          // If there's an error, reduce the padding, to serve the error text better, if not
                          // just put the usual padding as the others.
                          bottom: (_errorText != null) ? responsiveUI.own(0.02) : responsiveUI.own(0.045),
                        ),
                        child: TextFormField(
                          autofocus: false,
                          enableSuggestions: false,
                          controller: _authFieldController,
                          autovalidateMode: AutovalidateMode.always,
                          // Cannot edit when in progress.
                          enabled: (buttonState != ConfirmButtonState.inprogress),
                          style: styleText(fontSize: responsiveUI.normalSize),
                          cursorColor: App.themeColor.tertiary,
                          decoration: InputDecoration(
                            isDense: true,
                            focusColor: Colors.white,
                            hintText: 'Authentication Token*',
                            hintStyle: styleText(
                              fontSize: responsiveUI.normalSize,
                              color: App.themeColor.secondary.withAlpha(180),
                            ),
                            contentPadding: EdgeInsets.all(responsiveUI.own(0.01)),
                            errorText: _errorText,
                            errorMaxLines: 10,
                            errorStyle: styleText(
                              fontSize: responsiveUI.own(0.03),
                              color: Colors.red,
                            ),
                            icon: Icon(
                              Icons.key,
                              color: (_errorText != null) ? Colors.red : App.themeColor.tertiary,
                              size: responsiveUI.own(0.06),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                          validator: (token) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _validate(token);
                            });

                            return;
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
