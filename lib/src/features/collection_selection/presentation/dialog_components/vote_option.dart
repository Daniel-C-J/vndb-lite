import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection_selection/data/vote_data.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/footer_button_state.dart';
import 'package:vndb_lite/src/util/button_states.dart';

class RecordVoteOption extends ConsumerWidget {
  RecordVoteOption({super.key, required this.onChanged, required this.voteValue});

  final int voteValue;
  final Function(int) onChanged;

  final List<DropdownMenuItem> dropdownMenuItemWidgets = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonState = ref.watch(vnConfirmButtonStateProvider);

    if (dropdownMenuItemWidgets.length != VOTE_DATA.length) {
      //
      for (int voteRange in VOTE_DATA.keys) {
        if (voteRange == -1) continue;

        dropdownMenuItemWidgets.add(
          DropdownMenuItem(
            value: voteRange,
            child: ShadowText(VOTE_DATA[voteRange]!),
          ),
        );
      }
    }

    return IgnorePointer(
      ignoring: (buttonState == ConfirmButtonState.inprogress),
      child: Opacity(
        opacity: (buttonState == ConfirmButtonState.inprogress) ? 0.6 : 1,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            alignment: Alignment.center,
            isExpanded: true,
            isDense: true,
            onChanged: (value) {
              onChanged(value!);
            },
            items: dropdownMenuItemWidgets,
            hint: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ShadowText('Vote ('),
                ShadowText(
                  (voteValue == -1) ? '~' : '$voteValue',
                  color: App.themeColor.secondary,
                ),
                ShadowText(')'),
              ],
            ),
            menuItemStyleData: MenuItemStyleData(height: responsiveUI.own(0.1)),
            buttonStyleData: ButtonStyleData(
              height: responsiveUI.own(0.1),
              width: responsiveUI.own(0.27),
              padding: EdgeInsets.only(left: responsiveUI.own(0.02)),
              decoration: BoxDecoration(
                border: Border.all(color: App.themeColor.tertiary.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    App.themeColor.secondary.withOpacity(0.4),
                    App.themeColor.secondary.withOpacity(0.2),
                    App.themeColor.primary.withOpacity(0.2),
                    App.themeColor.primary.withOpacity(0.2),
                    App.themeColor.primary.withOpacity(0.4),
                  ],
                  end: Alignment.bottomLeft,
                  begin: Alignment.topRight,
                ),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Padding(
                padding: EdgeInsets.only(right: responsiveUI.own(0.02)),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: App.themeColor.tertiary,
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: responsiveUI.own(0.55),
              width: responsiveUI.own(0.4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.alphaBlend(
                      (App.themeColor.tertiary == Colors.white)
                          ? Colors.black.withOpacity(0.3)
                          : Colors.white.withOpacity(0.3),
                      App.themeColor.primary.withOpacity(0.8),
                    ),
                    App.themeColor.primary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 3,
                  )
                ],
              ),
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: const WidgetStatePropertyAll(5),
                thumbVisibility: const WidgetStatePropertyAll(true),
                thumbColor: WidgetStatePropertyAll(App.themeColor.secondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
