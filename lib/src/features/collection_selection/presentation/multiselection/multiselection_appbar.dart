import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/_base/presentation/maintab_layout.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/base_dialog.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/dialog_dismissed_state.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/vn_item_grid_.dart';

class MultiSelectionBarActions extends ConsumerWidget {
  const MultiSelectionBarActions({super.key});

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _selectAll(WidgetRef ref, List<VnItemGrid> p1List) async {
    // Doesn't like working with empty list.
    if (p1List.isEmpty) return;

    final selectedRecord = ref.read(recordSelectedControllerProvider);

    // For each vnData in the current status category, add them.
    for (VnItemGrid vnData in p1List) {
      final id = vnData.p1.id;

      if (selectedRecord.contains(id)) continue;
      selectedRecord.add(id);
    }

    ref.invalidate(recordSelectedControllerProvider);
    ref.read(recordSelectedControllerProvider.notifier).record = selectedRecord;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _inverseSelect(WidgetRef ref, List<VnItemGrid> p1List) async {
    if (p1List.isEmpty) return;

    final selectedRecord = ref.read(recordSelectedControllerProvider);

    for (VnItemGrid vnData in p1List) {
      final id = vnData.p1.id;

      if (selectedRecord.contains(id)) {
        selectedRecord.remove(id);
        //
      } else {
        //
        selectedRecord.add(id);
      }
    }

    ref.invalidate(recordSelectedControllerProvider);
    // Go back to default assuming multiselection mode deactivated by inversing none.
    if (selectedRecord.isEmpty) return;
    ref.read(recordSelectedControllerProvider.notifier).record = selectedRecord;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordSelected = ref.watch(recordSelectedControllerProvider);
    final sharedPref = ref.watch(sharedPrefProvider);

    return Expanded(
      child: Row(
        children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Back button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.02)),
            child: IconButton(
              highlightColor: Colors.white.withOpacity(0.25),
              onPressed: () async {
                final p1 = await ref.read(recordSelectedControllerProvider.notifier).convertToP1();
                if (p1.isEmpty) return;

                // Leaving only the first selected record to be preserved
                await showVnSelectionDialog(p1: [p1.first], isGridView: true);

                // Turning off multiselection mode
                if (ref.read(dialogDismissedStateProvider)) {
                  ref.invalidate(recordSelectedControllerProvider);
                }

                sharedPref.reload();
              },
              icon: Container(
                margin: EdgeInsets.only(left: responsiveUI.own(0.02)),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: responsiveUI.own(0.045),
                  color: App.themeColor.tertiary,
                ),
              ),
            ),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Number count selected
          ShadowText(
            '${recordSelected.length} selected',
            color: App.themeColor.tertiary,
            fontSize: responsiveUI.own(0.0525),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          const Spacer(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Select all
          Padding(
            padding: EdgeInsets.only(right: responsiveUI.own(0.02)),
            child: IconButton(
              highlightColor: Colors.white.withOpacity(0.25),
              tooltip: 'Select all',
              onPressed: () {
                // Get user current location in the collection tabs.
                final tabsArrangement = ref.read(settingsGeneralStateProvider).collectionStatusTabArrangement;
                final statusBasedOnIndex = tabsArrangement[collectionTabController.index];

                // For every vnData in the current status category, include them all.
                final collectionContent = ref.read(collectionContentControllerProvider);
                _selectAll(ref, collectionContent[statusBasedOnIndex]!);

                sharedPref.reload();
              },
              icon: Icon(Icons.select_all, color: App.themeColor.tertiary),
            ),
          ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Inverse selection
          Padding(
            padding: EdgeInsets.only(right: responsiveUI.own(0.02)),
            child: IconButton(
              tooltip: 'Select inverse',
              highlightColor: Colors.white.withOpacity(0.25),
              onPressed: () {
                // Get user current location in the collection tabs.
                final tabsArrangement = ref.read(settingsGeneralStateProvider).collectionStatusTabArrangement;
                final statusBasedOnIndex = tabsArrangement[collectionTabController.index];

                // For every vnData in the current status category, inverse them.
                final collectionContent = ref.read(collectionContentControllerProvider);
                _inverseSelect(ref, collectionContent[statusBasedOnIndex]!);

                sharedPref.reload();
              },
              icon: Icon(Icons.flip_to_back, color: App.themeColor.tertiary),
            ),
          )
        ],
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ),
    );
  }
}
