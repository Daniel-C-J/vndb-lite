import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:flutter/material.dart';

class GenericFailureConnection extends StatelessWidget {
  const GenericFailureConnection({
    super.key,
    this.customMessage,
  });

  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShadowText(
        customMessage ?? "There seems to be a connection error. Please try again later! :D",
        color: Colors.red,
        fontSize: responsiveUI.normalSize,
        align: TextAlign.center,
      ),
    );
  }
}
