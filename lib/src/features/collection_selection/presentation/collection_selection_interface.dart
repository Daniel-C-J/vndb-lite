import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/collection_selection_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/collection_selection_inprogress.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/date_option.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/footer_buttons.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/plus_button.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/status_option.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/vote_option.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

class VnSelection extends ConsumerWidget {
  const VnSelection(
    this.p1, {
    super.key,
    required this.isGridView,
  });

  final List<VnDataPhase01> p1;
  final bool isGridView;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If an ongoing progress exist then user shall not interrupt the progress
    // assuming that it would hurt the progress if related to collection.
    if (ref.watch(bottomProgressIndicatorProvider)) {
      return VnSelectionInprogress();
    }

    // vnTitles will be an indicator whether the selection is single or for multiple.
    final List<String> vnTitles = [for (VnDataPhase01 selectedVn in p1) selectedVn.title];

    // Initialization.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(vnSelectionControllerProvider);
      ref.read(vnSelectionControllerProvider.notifier).init(p1);
    });

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: ShadowText(
              "Save to collection",
              fontSize: responsiveUI.catgTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: App.themeColor.tertiary,
            height: responsiveUI.own(0.05),
          ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// VN Title(s)
          Padding(
            padding: EdgeInsets.only(top: responsiveUI.own(0.005)),
            child: ShadowText(
              vnTitles.join(',\n'),
              fontWeight: FontWeight.bold,
              fontSize: responsiveUI.own(0.036),
            ),
          ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Plus button for multi-selection
          if (App.isInCollectionScreen && !App.isInVnDetailScreen && isGridView)
            VnSelectionDialogPlusButton(data: p1),
          SizedBox(height: responsiveUI.own(0.015)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Status name
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ShadowText('Status: '),
                  Consumer(
                    builder: (context, ref, child) {
                      final selectionController = ref.watch(vnSelectionControllerProvider);

                      return ShadowText(
                        toBeginningOfSentenceCase<String>(selectionController.status),
                        color: App.themeColor.secondary,
                        fontWeight: FontWeight.bold,
                      );
                    },
                  ),
                ],
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Vote
              SizedBox(width: responsiveUI.own(0.1)),
              Consumer(
                builder: (context, ref, child) {
                  final selectionController = ref.watch(vnSelectionControllerProvider);

                  return RecordVoteOption(
                    onChanged: (value) {
                      ref.read(vnSelectionControllerProvider.notifier).copyWith(vote: value);
                    },
                    voteValue: selectionController.vote,
                  );
                },
              )
            ],
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Status icons
          SizedBox(height: responsiveUI.own(0.01)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              // alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (String vnStatusCode in COLLECTION_STATUS_DATA.keys)
                  Consumer(
                    builder: (context, ref, child) {
                      final selectionController = ref.watch(vnSelectionControllerProvider);

                      return RecordStatusOption(
                        onTap: () {
                          ref.read(vnSelectionControllerProvider.notifier).copyWith(status: vnStatusCode);
                        },
                        statusCode: vnStatusCode,
                        selectedIcon: selectionController.status,
                      );
                    },
                  ),
              ],
            ),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          SizedBox(height: responsiveUI.own(0.015)),
          const RecordDateOptions(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          SizedBox(height: responsiveUI.own(0.025)),
          VnSelectionDialogFooter(data: p1),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        ],
      ),
    );
  }
}
