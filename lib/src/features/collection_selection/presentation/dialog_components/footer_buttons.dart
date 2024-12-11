import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/common_widgets/generic_snackbar.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/application/collection_selection_service.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/dialog_dismissed_state.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/collection_selection_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialog_components/footer_button_state.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/remove_dialog.dart';
import 'package:vndb_lite/src/features/home/application/home_preview_service.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';
import 'package:vndb_lite/src/util/button_states.dart';

class VnSelectionDialogFooter extends ConsumerWidget {
  const VnSelectionDialogFooter({super.key, required this.data});

  final List<VnDataPhase01> data;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _showSnackbar({
    Color? color,
    required String text,
    required IconData icon,
  }) {
    GenericSnackBar(
      content: [
        Icon(
          icon,
          size: responsiveUI.snackbarIcon,
          color: color ?? App.themeColor.tertiary,
        ),
        SizedBox(width: responsiveUI.own(0.015)),
        Flexible(
            child: ShadowText(
          text,
          fontSize: responsiveUI.snackbarTxt,
        )),
      ],
      duration: const Duration(seconds: 4),
    ).show();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _notifyCollectionPreview() {
    ref_.invalidate(homePreviewServiceProvider);

    // Need to invalidate twice and a delay somehow...
    Future.delayed(Duration(milliseconds: 2400), () {
      ref_.invalidate(homePreviewServiceProvider);

      // Prevent changing collection refreshing the items which made the items disappear and force user to
      // go up from where the user scroll.
      if (!App.isInCollectionScreen) {
        ref_.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
      }
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.read(vnSelectionControllerProvider.notifier);

    // Watch states, to update UI.
    final selectionState = ref.watch(vnSelectionControllerProvider);
    final buttonState = ref.watch(vnConfirmButtonStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Cancel button
        CustomDialogButton(
          text: 'Cancel',
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: responsiveUI.own(0.025),
            horizontal: responsiveUI.own(0.035),
          ),
          onPressed: () async {
            // Turning off multiselection mode
            ref.invalidate(recordSelectedControllerProvider);

            // Dialog is not dimissed (cancelled).
            ref.read(dialogDismissedStateProvider.notifier).dismissed = false;

            Navigator.of(context).pop();
          },
        ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Remove button
        if (!selection.isVnNew && buttonState == ConfirmButtonState.normal)
          CustomDialogButton(
            text: 'Remove',
            padding: EdgeInsets.symmetric(
              vertical: responsiveUI.own(0.025),
              horizontal: responsiveUI.own(0.035),
            ),
            color: const Color.fromARGB(180, 255, 20, 0),
            onPressed: () async {
              if (buttonState == ConfirmButtonState.inprogress) return;

              await confirmVnRemovalDialog(() async {
                await selection.remove(
                  whenSuccess: () async {
                    // Turning off multiselection mode
                    ref.invalidate(recordSelectedControllerProvider);

                    // Dialog is not dimissed (cancelled).
                    ref.read(dialogDismissedStateProvider.notifier).dismissed = false;

                    // Notify collection preview
                    _notifyCollectionPreview();

                    // Closing dialogs
                    Navigator.of(context).pop(); // Pop removal confirmation
                    Navigator.of(context).pop(); // Pop selection dialog

                    _showSnackbar(
                      color: Colors.red,
                      text: 'Record removed.',
                      icon: Icons.delete_forever,
                    );
                  },
                  removeRefresh: (String id) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      ref.invalidate(vnRecordControllerProvider(id));
                      ref.read(vnRecordControllerProvider(id).notifier).importRecord(null);
                    });
                  },
                );
              });
            },
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Confirm button
        Opacity(
          opacity: (buttonState == ConfirmButtonState.normal) ? 1 : 0.6,
          child: CustomDialogButton(
            text: 'Confirm',
            color: App.themeColor.tertiary,
            textColor: App.themeColor.primary,
            textShadow: const [
              Shadow(color: Color.fromARGB(120, 0, 0, 0), blurRadius: 1),
            ],
            onPressed: () async {
              if (buttonState == ConfirmButtonState.inprogress) return;

              final changeButton = ref.read(vnConfirmButtonStateProvider.notifier);
              changeButton.state = ConfirmButtonState.inprogress;

              // Ugly... yet working.
              // TODO rearrange this, make it more elegant?

              // Used only once in a function, and this is an autodispose provider, so lint could be
              // ignored.
              ref.read(
                confirmSelectionProvider(
                  p1List: data,
                  selection: selectionState,
                  vnRecords: selection.vnRecords,
                  // ignore: provider_parameters
                  saveRefresh: (String id) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(const Duration(milliseconds: 800));
                      ref.invalidate(vnRecordControllerProvider(id));
                    });
                  },
                  // ignore: provider_parameters
                  whenSuccess: () async {
                    changeButton.state = ConfirmButtonState.normal;

                    // Turning off multiselection mode
                    ref.invalidate(recordSelectedControllerProvider);

                    // Dialog is not dimissed (cancelled).
                    ref.read(dialogDismissedStateProvider.notifier).dismissed = false;

                    // Notify collection preview.
                    _notifyCollectionPreview();

                    // Closing the dialog.
                    Navigator.of(context).pop();

                    if (selection.isMultiselection || !selection.isVnNew) {
                      return _showSnackbar(
                        text: 'Updated.',
                        icon: Icons.update,
                      );
                    }

                    _showSnackbar(
                      text: 'Added to library.',
                      icon: Icons.library_add_check,
                    );
                  },
                  // ignore: provider_parameters
                  whenErr: (err, st) {
                    // print(err);
                    // print(st);
                    //TODO better error handl message
                    changeButton.state = ConfirmButtonState.normal;
                    _showSnackbar(
                      color: Colors.red,
                      text: 'An error occurred... Please try again later.',
                      icon: Icons.error_outline,
                    );
                  },
                ),
              );
            },
            additionalWidget: (buttonState == ConfirmButtonState.inprogress)
                ? SizedBox(
                    width: responsiveUI.own(0.05),
                    height: responsiveUI.own(0.05),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : null,
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
