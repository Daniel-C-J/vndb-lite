import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/common_widgets/generic_snackbar.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

void feedbackSnackBar({
  required String text,
  IconData? icon,
  Color? iconColor,
  Color? txtColor,
}) {
  final snackbar = GenericSnackBar(
    content: [
      (icon != null)
          ? Icon(
              icon,
              color: iconColor ?? App.themeColor.tertiary,
              size: responsiveUI.snackbarIcon,
            )
          : const SizedBox.shrink(),
      SizedBox(width: responsiveUI.own(0.015)),
      Flexible(
        child: ShadowText(
          text,
          fontSize: responsiveUI.snackbarTxt,
          color: txtColor ?? Colors.white,
        ),
      ),
    ],
    duration: const Duration(milliseconds: 2000),
  );

  snackbar.show();
  return;
}
