import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/multi_selection_indicator.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_item_detail_label.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_item_detail_status_indicator.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_item_detail_title.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/vn_item_grid_controller.dart';

class VnItemGridDetails extends StatelessWidget {
  const VnItemGridDetails({
    super.key,
    required this.p1,
    required this.toggleVnDetailSummary,
    this.labelCode = 'title',
  });

  final VnDataPhase01 p1;

  final String labelCode;

  final VoidCallback toggleVnDetailSummary;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VnItemDetailLabel(p1: p1, labelCode: labelCode),
            VnItemDetailTitle(title: p1.title),
          ],
        ),
        VnItemDetailStatusIndicator(
          id: p1.id,
          toggleVnDetailSummary: toggleVnDetailSummary,
        ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Multi-selection mode.
        Consumer(
          builder: (context, ref, child) {
            final recordSelected = ref.watch(recordSelectedControllerProvider);
            final almostLongPressed = ref.watch(vnItemGridAlmostLongPressedStateProvider);

            if (recordSelected.contains(p1.id) || almostLongPressed == p1.id) {
              return const MultiSelectionIndicator();
            }

            return const SizedBox.shrink();
          },
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
