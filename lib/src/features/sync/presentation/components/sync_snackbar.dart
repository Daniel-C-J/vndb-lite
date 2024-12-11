import 'package:flutter/material.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/common_widgets/generic_snackbar.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

void snackBarSyncStatus(
  String text, {
  required IconData icon,
  required Color iconColor,
}) {
  final snackbar = GenericSnackBar(
    duration: const Duration(milliseconds: 4500),
    content: [
      Icon(
        icon,
        color: iconColor,
        size: responsiveUI.snackbarIcon,
      ),
      SizedBox(width: responsiveUI.own(0.015)),
      Flexible(
        child: ShadowText(
          text,
          fontSize: responsiveUI.snackbarTxt,
        ),
      ),
    ],
  );

  snackbar.show();
  return;
}
