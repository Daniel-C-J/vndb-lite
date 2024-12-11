import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/sync/application/sync_service.dart';
import 'package:vndb_lite/src/features/sync/presentation/auth_screen_controller.dart';
import 'package:vndb_lite/src/features/sync/presentation/components/sync_snackbar.dart';
import 'package:vndb_lite/src/features/sync/presentation/dialog/sync_dialog.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

class AppBarSyncButton extends ConsumerWidget {
  const AppBarSyncButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uId = ref.watch(authScreenControllerProvider.notifier);

    return IconButton(
      tooltip: 'Sync',
      highlightColor: Colors.white.withOpacity(0.25),
      onPressed: () async {
        if (!ref.read(bottomProgressIndicatorProvider)) {
          try {
            // If already synced once, don't show dialog anymore.
            if (uId.isUserSynced()) {
              ref.read(bottomProgressIndicatorProvider.notifier).show = true;

              await ref.read(syncServiceProvider(snackbar: snackBarSyncStatus)).sync(
                    keepVns: true,
                    // Will updates collection periodically.
                    whenDownloadingAndSaving: () async {
                      await ref_.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
                    },
                  );

              ref_.invalidate(vnRecordControllerProvider);
              ref_.read(bottomProgressIndicatorProvider.notifier).show = false;
              return;
            }

            await showSyncDialog();
            return;
            //
          } catch (e) {
            // TODO catch e
            ref_.read(bottomProgressIndicatorProvider.notifier).show = false;
            // print(e);
          }
        }
      },
      icon: Icon(
        Icons.sync,
        size: responsiveUI.standardIcon,
        color: App.themeColor.tertiary,
      ),
    );
  }
}
