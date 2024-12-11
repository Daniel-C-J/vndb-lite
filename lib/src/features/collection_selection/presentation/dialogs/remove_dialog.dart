import 'package:flutter/material.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

Future<void> confirmVnRemovalDialog(VoidCallback removeVn) {
  return showDialog(
    context: NavigationService.currentContext,
    builder: (BuildContext context) {
      return CustomDialog(
        useContentPadding: true,
        content: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: ShadowText(
                "Remove Visual Novel from collection?",
                fontSize: responsiveUI.catgTitle,
              ),
            ),
            SizedBox(height: responsiveUI.own(0.03)),
            Container(
              alignment: Alignment.centerRight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Confirm button

                  CustomDialogButton(
                    text: 'Yep',
                    color: const Color.fromARGB(180, 255, 20, 0),
                    onPressed: removeVn,
                  ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Cancel button
                  CustomDialogButton(
                    text: 'Cancel',
                    color: Colors.transparent,
                    onPressed: Navigator.of(context).pop,
                  ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
