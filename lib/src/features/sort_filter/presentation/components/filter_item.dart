import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

// TODO filter options lag.
class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.title,
    required this.isOpened,
    required this.onTap,
  });

  final String title;
  final bool isOpened;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          selected: true,
          selectedTileColor: App.themeColor.secondary.withOpacity(0.3),
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsiveUI.own(0.045),
            vertical: responsiveUI.own(0.005),
          ),
          title: ShadowText(title),
          trailing: Icon(
            (isOpened) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: App.themeColor.tertiary,
            size: responsiveUI.own(0.06),
          ),
        ),
      ),
    );
  }
}
