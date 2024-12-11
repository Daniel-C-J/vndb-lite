import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/vn_item_grid_controller.dart';

class VnItemDetailStatusIndicator extends ConsumerWidget {
  const VnItemDetailStatusIndicator({
    super.key,
    required this.id,
    required this.toggleVnDetailSummary,
  });

  final String id;
  final VoidCallback toggleVnDetailSummary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final almostLongPressed = ref.watch(vnItemGridAlmostLongPressedStateProvider);
    final recordSelected = ref.watch(recordSelectedControllerProvider);
    final vnRecord = ref.watch(vnRecordControllerProvider(id));

    // If current vnId exists in multiSelectedVns, or it's just almost long pressed.
    if (recordSelected.contains(id) || almostLongPressed == id) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: 0,
      top: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Go to [VnItemDetailSummary].
          toggleVnDetailSummary();
        },
        child: Container(
          // color: Colors.red,
          width: responsiveUI.own(0.1),
          height: responsiveUI.own(0.1),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: App.themeColor.primary.withOpacity(0.8),
              ),
              child: Icon(
                Icons.info_outline,
                color: (vnRecord != null) ? COLLECTION_STATUS_DATA[vnRecord.status]!.color : Colors.white,
                size: responsiveUI.own(0.055),
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
