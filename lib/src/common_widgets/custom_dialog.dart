import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';

class CustomDialog extends ConsumerWidget {
  const CustomDialog({
    super.key,
    required this.content,
    required this.useContentPadding,
  });

  final Widget content;
  final bool useContentPadding;

  static final double borderRadius = 36.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      elevation: 8,
      scrollable: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      // Inner layer constraints
      contentPadding: (useContentPadding) ? EdgeInsets.all(responsiveUI.own(0.045)) : EdgeInsets.zero,
      backgroundColor: App.themeColor.primary.withOpacity(0.8),
      // Outer layer constraints
      content: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).height * .8,
        ),
        child: content,
      ),
    );
  }
}
