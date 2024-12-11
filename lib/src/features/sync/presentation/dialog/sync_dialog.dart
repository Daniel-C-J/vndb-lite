import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/home/data/local/local_home_repo.dart';
import 'package:vndb_lite/src/features/sync/application/sync_service.dart';
import 'package:vndb_lite/src/features/sync/presentation/components/sync_snackbar.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

Future<void> showSyncDialog() async {
  return await showDialog(
    barrierDismissible: false,
    context: NavigationService.currentContext,
    builder: (_) {
      return PopScope(
        canPop: false,
        child: Consumer(
          builder: (context, ref, child) {
            // A fast method to get local collections.
            final collection = ref.watch(localHomeRepoProvider).getInstantLocalPreview();

            return CustomDialog(
              useContentPadding: true,
              content: Column(
                children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Title & Content
                  ShadowText(
                    "Authentication Success!",
                    align: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    fontSize: responsiveUI.catgTitle,
                  ),
                  SizedBox(height: responsiveUI.own(0.01)),
                  ShadowText(
                    (collection.isEmpty)
                        ? "Do you want to synchronize your VNs now?"
                        : "Do you want to synchronize your VNs now? \nIf so, do you want to keep the items in your "
                            "local collection? Or merge them with the items in your account?",
                    align: TextAlign.center,
                  ),
                  SizedBox(height: responsiveUI.own(0.02)),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Yes
                      CustomDialogButton(
                        text: (collection.isEmpty) ? "Yes" : "Keep, merge, and sync my VNs",
                        textColor: App.themeColor.primary,
                        textShadow: const [
                          Shadow(color: Color.fromARGB(120, 0, 0, 0), blurRadius: 1),
                        ],
                        color: App.themeColor.tertiary,
                        leading: Padding(
                          padding: EdgeInsets.only(right: responsiveUI.own(0.01)),
                          child: Icon(
                            Icons.library_add_check,
                            color: Colors.green,
                            size: responsiveUI.own(0.05),
                          ),
                        ),
                        onPressed: () async {
                          // Emergency ref to be used even after dialog disposal.
                          Navigator.of(context).pop();
                          ref_.read(bottomProgressIndicatorProvider.notifier).show = true;

                          try {
                            await ref_.read(syncServiceProvider(snackbar: snackBarSyncStatus)).sync(
                                  keepVns: true,
                                  whenDownloadingAndSaving: () async {
                                    // Updates collection periodically.
                                    await ref_
                                        .read(collectionContentControllerProvider.notifier)
                                        .separateVNsByStatus();
                                  },
                                );
                            ref_.invalidate(vnRecordControllerProvider);
                            //
                          } catch (e) {
                            //
                          } finally {
                            ref_.read(bottomProgressIndicatorProvider.notifier).show = false;
                          }
                        },
                      ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// No
                      if (collection.isNotEmpty)
                        CustomDialogButton(
                          text: "Delete them and sync my VNs",
                          textColor: App.themeColor.primary,
                          textShadow: const [
                            Shadow(color: Color.fromARGB(120, 0, 0, 0), blurRadius: 1),
                          ],
                          color: App.themeColor.tertiary,
                          leading: Padding(
                            padding: EdgeInsets.only(right: responsiveUI.own(0.01)),
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: responsiveUI.own(0.05),
                            ),
                          ),
                          onPressed: () async {
                            // Emergency ref to be used even after dialog disposal.
                            Navigator.of(context).pop();
                            ref_.read(bottomProgressIndicatorProvider.notifier).show = true;

                            try {
                              await ref_.read(syncServiceProvider(snackbar: snackBarSyncStatus)).sync(
                                    keepVns: false,
                                    whenDownloadingAndSaving: () async {
                                      // Updates collection periodically
                                      await ref_
                                          .read(collectionContentControllerProvider.notifier)
                                          .separateVNsByStatus();
                                    },
                                  );
                              ref_.invalidate(vnRecordControllerProvider);
                              //
                            } catch (e) {
                              // TODO catch e
                            } finally {
                              ref_.read(bottomProgressIndicatorProvider.notifier).show = false;
                            }
                          },
                        ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Nah, later
                      CustomDialogButton(
                        text: (collection.isEmpty) ? "Not now" : "Nah, I'll do it later",
                        color: Colors.transparent,
                        onPressed: () {
                          ref_.read(bottomProgressIndicatorProvider.notifier).show = false;
                          Navigator.of(context).pop();
                        },
                      ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
