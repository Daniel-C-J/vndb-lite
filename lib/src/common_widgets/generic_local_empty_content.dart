import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:flutter/material.dart';

class GenericLocalEmptyWidget extends StatelessWidget {
  const GenericLocalEmptyWidget({
    super.key,
    this.customMessage,
  });

  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShadowText(
        customMessage ?? "Oops, nothing's here yet! Maybe try adding some :) ?",
        fontSize: responsiveUI.normalSize,
        align: TextAlign.center,
      ),
    );
  }
}
