import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/collection_selection_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/dialog_dismissed_state.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

class VnSelectionDialogPlusButton extends ConsumerWidget {
  const VnSelectionDialogPlusButton({super.key, required this.data});

  final List<VnDataPhase01> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(vnSelectionControllerProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(top: responsiveUI.own(0.01)),
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: () {
          // Triggering Multi-selection mode
          selection.setToMultiselection(data);

          // Dialog is not dimissed (cancelled).
          ref.read(dialogDismissedStateProvider.notifier).dismissed = false;

          Navigator.of(context).pop();
        },
        child: Opacity(
          opacity: 0.7,
          child: Container(
            padding: EdgeInsets.all(responsiveUI.own(0.018)),
            decoration: BoxDecoration(
              color: App.themeColor.primary,
              borderRadius: BorderRadius.circular(36),
              boxShadow: const [
                BoxShadow(color: Colors.black, blurRadius: 3),
              ],
            ),
            child: Icon(
              Icons.add,
              size: responsiveUI.own(0.06),
              color: App.themeColor.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
