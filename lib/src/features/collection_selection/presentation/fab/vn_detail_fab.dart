import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/base_dialog.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/fab/vn_detail_fab_state.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';

class VnDetailFab extends ConsumerWidget {
  const VnDetailFab({
    super.key,
    required this.p1,
  });

  final VnDataPhase01 p1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(vnRecordControllerProvider(p1.id));

    // The reason this does not renders the floating action button immediately is when a given scenario for
    // a detail screen stucks at downloading the phase02 data, user can crash the widget by clicking the
    // FAB to add the vn to the collection, meanwhile collection requires both phase01 and phase02 data.
    if (ref.watch(vnDetailFabStateProvider(p1.id))) {
      final bool recordExist = record != null;

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
          heroTag: "detailSelection",
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          tooltip: (recordExist) ? 'Already in collection' : 'Add to collection',
          onPressed: () async {
            await showVnSelectionDialog(p1: [p1], isGridView: false);
          },
          child: Icon(
            (recordExist) ? Icons.library_add_check : Icons.library_add,
            color: App.themeColor.tertiary,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
