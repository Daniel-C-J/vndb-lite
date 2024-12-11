import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/collection_selection_interface.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/dialog_dismissed_state.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

Future<void> showVnSelectionDialog({
  required List<VnDataPhase01> p1,
  required final bool isGridView,
}) async {
  return await showDialog(
    context: NavigationService.currentContext,
    barrierDismissible: true,
    useSafeArea: true,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          // Setting dialog dismissed state back to default true, and will be false either:
          // Tapping cancel, remove, confirm, or plus button.
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ref.invalidate(dialogDismissedStateProvider);
          });

          return CustomDialog(
            useContentPadding: true,
            content: VnSelection(p1, isGridView: isGridView),
          );
        },
      );
    },
  );
}
