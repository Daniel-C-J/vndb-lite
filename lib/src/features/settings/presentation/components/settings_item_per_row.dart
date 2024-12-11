import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/settings/presentation/components/settings_listview_scroll_items.dart';

class SettingsItemPerRow extends ConsumerStatefulWidget {
  const SettingsItemPerRow({
    super.key,
    required this.initialPortraitValue,
    required this.initialLandscapeValue,
    required this.onSelectedItemChangedPortrait,
    required this.onSelectedItemChangedLandscape,
  });

  final int initialPortraitValue;
  final int initialLandscapeValue;
  final void Function(int) onSelectedItemChangedPortrait;
  final void Function(int) onSelectedItemChangedLandscape;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsItemPerRowState();
}

class _SettingsItemPerRowState extends ConsumerState<SettingsItemPerRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: responsiveUI.own(0.05),
        top: responsiveUI.own(0.02),
        bottom: responsiveUI.own(0.01),
        left: responsiveUI.own(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              ShadowText('Portrait'),
              SizedBox(height: responsiveUI.own(0.02)),
              Container(
                width: responsiveUI.own(0.1),
                height: responsiveUI.own(0.25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Color.alphaBlend(
                      App.themeColor.secondary.withOpacity(0.4),
                      App.themeColor.tertiary.withOpacity(0.6),
                    ),
                    width: 1.5,
                  ),
                ),
                child: ListviewScrollItem(
                  initialItemController: widget.initialPortraitValue - 2,
                  onSelectedItemChanged: widget.onSelectedItemChangedPortrait,
                  // Maximum 8.
                  children: List.generate(
                    7,
                    (idx) {
                      return ShadowText(
                        (idx + 2).toString(),
                        fontSize: responsiveUI.own(0.04),
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              ShadowText('Landscape'),
              SizedBox(height: responsiveUI.own(0.02)),
              Container(
                width: responsiveUI.own(0.1),
                height: responsiveUI.own(0.25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Color.alphaBlend(
                      App.themeColor.secondary.withOpacity(0.4),
                      App.themeColor.tertiary.withOpacity(0.6),
                    ),
                    width: 1.5,
                  ),
                ),
                child: ListviewScrollItem(
                  initialItemController: widget.initialLandscapeValue - 4,
                  onSelectedItemChanged: widget.onSelectedItemChangedLandscape,
                  // Maximum 8. (5 + 4 - 1) since index starts at 0, thus minus 1 to get the actual value.
                  children: List.generate(5, (idx) {
                    return ShadowText(
                      (idx + 4).toString(),
                      fontSize: responsiveUI.own(0.04),
                      color: Colors.white,
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
