import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/dialog_dismissed_state.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/base_dialog.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';

class MultiSelectFab extends ConsumerWidget {
  const MultiSelectFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordSelected = ref.watch(recordSelectedControllerProvider);
    final sharedPref = ref.watch(sharedPrefProvider);

    if (recordSelected.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              App.themeColor.primary.withOpacity(0.8),
              App.themeColor.primary.withOpacity(0.5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(90, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, responsiveUI.own(0.005)),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: "multiSelection",
          elevation: 0,
          highlightElevation: 0,
          tooltip: 'Process selected VNs',
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          onPressed: () async {
            final p1List = await ref.read(recordSelectedControllerProvider.notifier).convertToP1();
            await showVnSelectionDialog(p1: p1List, isGridView: true);

            // Turning off multiselection mode
            if (ref.read(dialogDismissedStateProvider)) {
              ref.invalidate(recordSelectedControllerProvider);
            }

            sharedPref.reload();

            // Refreshing vn item's record indicator, after multiselection changes made
            for (VnDataPhase01 p1 in p1List) {
              ref.invalidate(vnRecordControllerProvider(p1.id));
            }
          },
          child: Icon(Icons.check, color: App.themeColor.tertiary),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
