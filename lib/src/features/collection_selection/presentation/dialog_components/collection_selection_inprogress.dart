import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

class VnSelectionInprogress extends StatelessWidget {
  const VnSelectionInprogress({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: ShadowText(
            "Save to collection",
            fontSize: responsiveUI.catgTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: App.themeColor.tertiary,
          height: responsiveUI.own(0.05),
        ),
        ShadowText(
          'Please wait until the current process is complete. Thank you :3',
        ),
        SizedBox(height: responsiveUI.own(0.025)),
        CustomDialogButton(
          text: "Okay",
          textColor: App.themeColor.primary,
          color: App.themeColor.tertiary,
          onPressed: Navigator.of(context).pop,
          textShadow: const [Shadow(color: Color.fromARGB(120, 0, 0, 0), blurRadius: 1)],
        )
      ],
    );
  }
}
