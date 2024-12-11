import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/footer_button_state.dart';
import 'package:vndb_lite/src/util/button_states.dart';

class RecordStatusOption extends ConsumerWidget {
  const RecordStatusOption({
    super.key,
    required this.onTap,
    required this.selectedIcon,
    required this.statusCode,
  });

  final void Function() onTap;
  final String selectedIcon;
  final String statusCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonState = ref.watch(vnConfirmButtonStateProvider);

    final statusOption = COLLECTION_STATUS_DATA[statusCode]!;
    final isMultiselection = selectedIcon.toLowerCase() == 'mixed';

    return Padding(
      padding: EdgeInsets.only(
        top: responsiveUI.own(0.02),
        bottom: responsiveUI.own(0.02),
        right: responsiveUI.own(0.01),
        left: responsiveUI.own(0.01),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (buttonState == ConfirmButtonState.inprogress) return;
          onTap();
        },
        child: Opacity(
          opacity: (isMultiselection || buttonState == ConfirmButtonState.inprogress)
              ? 0.8
              : (selectedIcon == statusCode)
                  ? 1
                  : 0.6,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  App.themeColor.primary,
                  App.themeColor.primary.withOpacity(0.5),
                ],
              ),
              border: Border.all(
                width: responsiveUI.own(0.005),
                color: (selectedIcon == statusCode || isMultiselection)
                    ? statusOption.color
                    : const Color.fromARGB(50, 0, 0, 0),
              ),
            ),
            padding: EdgeInsets.all(responsiveUI.own(0.01)),
            child: Stack(
              children: [
                Image.asset(
                  statusOption.imagePath!,
                  color: Colors.black,
                  width: responsiveUI.own(0.068),
                  height: responsiveUI.own(0.08),
                  opacity: (selectedIcon == statusCode || selectedIcon.toLowerCase() == 'mixed')
                      ? const AlwaysStoppedAnimation(0.4)
                      : const AlwaysStoppedAnimation(0),
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Image.asset(
                      statusOption.imagePath!,
                      width: responsiveUI.own(0.068),
                      height: responsiveUI.own(0.08),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
