import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:flutter/material.dart';

class GenericError extends StatelessWidget {
  const GenericError({
    super.key,
    this.customMessage,
  });

  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShadowText(
        customMessage ?? "There seems to be an error... :(",
        color: Colors.red,
        fontSize: responsiveUI.normalSize,
        align: TextAlign.center,
      ),
    );
  }
}
