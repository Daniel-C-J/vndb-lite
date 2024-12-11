import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

Future<void> showSettingsDialog({
  required String title,
  bool yesOrNo = false,
  Color? yesButtonColor,
  Function()? yesFunction,
  Widget? content,
}) {
  return showDialog(
    context: NavigationService.currentContext,
    builder: (context) {
      return CustomDialog(
        useContentPadding: false,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Title
            Container(
              padding: EdgeInsets.only(
                top: responsiveUI.own(0.05),
                left: responsiveUI.own(0.05),
                right: responsiveUI.own(0.05),
              ),
              alignment: Alignment.centerLeft,
              child: ShadowText(
                title,
                fontSize: responsiveUI.catgTitle,
              ),
            ),
            if (content != null) SizedBox(height: responsiveUI.own(0.01)),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Real Content
            content ?? const SizedBox.shrink(),
            SizedBox(height: responsiveUI.own(0.04)),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Buttons
            Container(
              padding: EdgeInsets.only(
                right: responsiveUI.own(0.05),
                bottom: responsiveUI.own(0.05),
              ),
              alignment: Alignment.centerRight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Confirm button
                  if (yesOrNo)
                    CustomDialogButton(
                      text: "Confirm",
                      textColor: (yesButtonColor != null) ? App.themeColor.tertiary : App.themeColor.primary,
                      color: yesButtonColor ?? App.themeColor.tertiary,
                      onPressed: () {
                        yesFunction!();
                        Navigator.of(context).pop();
                      },
                    ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Cancel

                  CustomDialogButton(
                    text: "Cancel",
                    color: Colors.transparent,
                    onPressed: () => Navigator.of(context).pop(),
                  ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
