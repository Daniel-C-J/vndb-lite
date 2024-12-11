import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/common_widgets/generic_snackbar.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/_base/presentation/maintab_layout.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/collection_selection_controller.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/dialogs/dialog_dismissed_state.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/home/application/home_preview_service.dart';
import 'package:vndb_lite/src/features/search/presentation/search_screen_controller.dart';
import 'package:vndb_lite/src/features/settings/application/settings_service.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_data_state.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme_state.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sync/presentation/components/auth_confirm_button_state.dart';
import 'package:vndb_lite/src/features/sync/presentation/components/auth_token_field_controller.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

class AppBarRefreshButton extends ConsumerWidget {
  const AppBarRefreshButton({super.key});

  // This will use emergency global ref_ to prevent error when the corresponding ref disposed.
  static Future<void> tap({bool allMainScreen = false, bool verbose = false}) async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Not using else if, since if using such flow, the argument allMainScreen will
      // only exeuted once with the first true condition.
      if (App.isInHomeScreen || allMainScreen) {
        ref_.invalidate(homePreviewServiceProvider);
        ref_.read(homePreviewServiceProvider).refreshRemotePreviews();
      }

      if (App.isInSearchScreen || allMainScreen) {
        final remoteSearchQuery = ref_.read(appliedRemoteFilterControllerProvider).search;
        final altRemoteSearchQuery = ref_.read(tempRemoteFilterControllerProvider).search;

        // Empty the results.
        ref_.invalidate(searchResultNotifierProvider);
        ref_.invalidate(searchScreenControllerProvider);
        ref_.read(searchScreenControllerProvider.notifier).resetState();

        // Will do a research if search query is not empty.
        if (remoteSearchQuery.isNotEmpty || altRemoteSearchQuery.isNotEmpty || allMainScreen) {
          ref_.read(searchScreenControllerProvider.notifier).searchWithCurrentConf();
        }
      }

      // Refreshing the collection content.
      if (App.isInCollectionScreen || allMainScreen) {
        await ref_.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
      }

      resetTempData();

      // Refreshing the settings throughout the whole app.
      ref_.invalidate(settingsGeneralStateProvider);
      ref_.invalidate(settingsThemeStateProvider);
      ref_.invalidate(settingsDataStateProvider);
    });
  }

  /// Resetting almost all temporary keepAlive:true providers.
  static void resetTempData({bool verbose = false}) {
    ref_.invalidate(recordSelectedControllerProvider);
    ref_.invalidate(vnSelectionControllerProvider);
    ref_.invalidate(dialogDismissedStateProvider);

    ref_.invalidate(authConfirmButtonStateProvider);
    ref_.invalidate(showAuthTokenFieldStateProvider);
    ref_.invalidate(authTokenFieldServerErrorControllerProvider);

    ref_.invalidate(vnRecordControllerProvider);

    if (verbose) {
      textControllerCollection.clear();
      textControllerSearch.clear();

      ref_.invalidate(appliedRemoteFilterControllerProvider);
      ref_.invalidate(appliedRemoteSortControllerProvider);
      ref_.invalidate(tempRemoteFilterControllerProvider);
      ref_.invalidate(tempRemoteSortControllerProvider);

      ref_.read(localSortControllerProvider.notifier).reset();
      ref_.read(localFilterControllerProvider.notifier).reset();
      ref_.invalidate(collectionContentControllerProvider);

      ref_.invalidate(bottomProgressIndicatorProvider);
      ref_.invalidate(settingsServiceProvider);
    }
  }

  void _showRefreshingSnackbar() {
    GenericSnackBar(
      duration: const Duration(milliseconds: 2500),
      content: [
        Icon(
          Icons.refresh,
          color: App.themeColor.tertiary,
          size: responsiveUI.snackbarIcon,
        ),
        SizedBox(width: responsiveUI.own(0.015)),
        ShadowText(
          'Refreshing...',
          fontSize: responsiveUI.snackbarTxt,
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      // Using padding since this button sits at the rightmost corner of the appbar.
      padding: EdgeInsets.only(right: responsiveUI.own(0.02)),
      child: IconButton(
        tooltip: 'Refresh',
        highlightColor: Colors.white.withOpacity(0.25),
        onPressed: () async {
          // Do nothing if there's an ongoing process.
          if (ref.read(bottomProgressIndicatorProvider)) return;

          ref.read(bottomProgressIndicatorProvider.notifier).show = true;
          _showRefreshingSnackbar();

          try {
            await AppBarRefreshButton.tap();
            //
          } catch (e) {
            debugPrint(e.toString());
            //
          } finally {
            // Wait for a moment until stopping the progress indicator.
            await Future.delayed(const Duration(milliseconds: 2500), () {
              ref_.read(bottomProgressIndicatorProvider.notifier).show = false;
            });
          }
        },
        icon: Icon(
          Icons.refresh,
          color: App.themeColor.tertiary,
          size: responsiveUI.standardIcon,
        ),
      ),
    );
  }
}
