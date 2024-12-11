import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/generic_failure_connection.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/common_widgets/generic_snackbar.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/chart/presentation/stat_chart.dart';
import 'package:vndb_lite/src/features/search/data/remote/remote_search_repo.dart';
import 'package:vndb_lite/src/features/search/presentation/search_result.dart';
import 'package:vndb_lite/src/features/search/presentation/search_result_controller.dart';
import 'package:vndb_lite/src/features/search/presentation/search_screen_controller.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_summary/vn_item_detail_summary_scroll_state.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  void _showConnectionErrorSnackbar() {
    final snackbar = GenericSnackBar(
      duration: const Duration(milliseconds: 6000),
      content: [
        Icon(
          Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
          color: Colors.red,
          size: responsiveUI.snackbarIcon,
        ),
        SizedBox(width: responsiveUI.own(0.015)),
        Flexible(
          child: ShadowText(
            'Connection error. Please try again later.',
            fontSize: responsiveUI.snackbarTxt,
          ),
        ),
      ],
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      GenericSnackBar.hide();
      snackbar.show();
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// These functions exists because of how the searchScreenController state value, is only
// returning FutureBuilder<dynamic>, not what the FutureBuilder itself returns.
// Thus placeholders, and something like that need to be synthetically injected to the state.

  void _readyToRefetch() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(searchResultPageControllerProvider.notifier).decrement();
      }
    });
  }

  void _setNoResultYetSearchIndicator() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(searchScreenControllerProvider.notifier).add(const SizedBox.shrink());
      }
    });
  }

  void _removeErrorOrLoadingWidget({bool once = false}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final results = ref.read(searchScreenControllerProvider);

      if (!mounted) return;

      if (results.isNotEmpty && results.last is SizedBox) {
        // 1. Remove the sizedBox
        ref.read(searchScreenControllerProvider.notifier).removeLast();
        if (once || results.isEmpty) return;

        // 2. Remove the latest result that caused the sizedBox
        ref.read(searchScreenControllerProvider.notifier).removeLast();
      }
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _initiateSearch(int pageResult) {
    final sortData = ref.read(appliedRemoteSortControllerProvider);
    final filterData = ref.read(appliedRemoteFilterControllerProvider);

    final remoteRepo = ref.read(remoteSearchRepoProvider);
    final requestData = remoteRepo.formatRemoteSearchRequest(
      pageResult: pageResult,
      sortData: sortData,
      filterData: filterData,
    );

    return FutureBuilder(
      future: remoteRepo.remoteSearchVn(requestData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _removeErrorOrLoadingWidget();
          _setNoResultYetSearchIndicator();

          // Show loading widget
          return SizedBox(
            height: (pageResult > 1)
                ? MediaQuery.sizeOf(context).height * 0.2 // Appending existing result
                : MediaQuery.sizeOf(context).height * 0.65, // First-time result
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          _showConnectionErrorSnackbar();
          _removeErrorOrLoadingWidget();
          _readyToRefetch();

          // Configured in ApiService class for a scenario when no internet connection,
          // the exception type goes with connectionTimeout.
          if ((snapshot.error as DioException).type == DioExceptionType.connectionTimeout && pageResult > 1) {
            return const SizedBox.shrink();
          }

          // For a none no internet connection error, the way to continue searching is blocked,
          // until the user refreshes the search.
          _setNoResultYetSearchIndicator();

          // TODO better network error UI?
          return SizedBox(
            height: (pageResult > 1)
                ? MediaQuery.sizeOf(context).height * 0.2 // Appending existing result
                : MediaQuery.sizeOf(context).height * 0.65, // First-time result
            child: const GenericFailureConnection(),
          );
        }

        // Only removing the sizedBox placeholder.
        _removeErrorOrLoadingWidget(once: true);
        final result = snapshot.data?.data['results'];

        if (result.isEmpty || result == null) {
          // Will not be able continue
          _setNoResultYetSearchIndicator();

          return Center(
            child: Padding(
              padding: EdgeInsets.all(responsiveUI.own(0.1)),
              child: ShadowText(
                "No further results ;)",
              ),
            ),
          );
        }

        // Communicate with searchResultController that will present the widgets item from
        // formatting the raw response into the classified model then to the widgets.
        final labelCode =
            (requestData.sort! == SortableCode.searchrank.name) ? SortableCode.title.name : requestData.sort!;
        final p1 = remoteRepo.p1FromResponse(result);

        // Append the result to the controller, and should update UI.
        ref.read(searchResultControllerProvider.notifier).fromP1(p1, labelCode);

        // Only for the first time result, it will show the SearchResult widget, but afterwards the result will
        // just append the already existing searchResult from searchResultProvider.
        if (pageResult == 1) {
          return const SearchResult();
        }

        return const SizedBox.shrink();
      },
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsGeneralStateProvider);
    final searchFilter = ref.watch(appliedRemoteFilterControllerProvider).search;

    // Shows default widget in search screen based on configured settings, and search screen state.
    if (searchFilter.isEmpty) {
      if (settings.showChart) return const VNDBStatsChart();
      return const SizedBox.shrink();
    }

    // Why there's a TapRegion? It's to prevent scrolling confusion between vnItem detail summary,
    // and the vnData search results.
    return TapRegion(
      behavior: HitTestBehavior.opaque,
      onTapInside: (_) => ref.read(vnItemSummaryScrollStateProvider.notifier).isScrolling = false,
      onTapOutside: (_) => ref.read(vnItemSummaryScrollStateProvider.notifier).isScrolling = true,
      child: Padding(
        padding: EdgeInsets.only(
          left: responsiveUI.own(0.025),
          right: measureSafeAreaOf(responsiveUI.own(0.025)),
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final searchNotify = ref.watch(searchResultNotifierProvider);
            final pageResult = ref.watch(searchResultPageControllerProvider);

            if (searchNotify) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ref.read(searchResultNotifierProvider.notifier).end();
                ref.read(searchScreenControllerProvider.notifier).add(_initiateSearch(pageResult));
              });
            }

            final state = ref.watch(searchScreenControllerProvider);
            return Wrap(children: state);
          },
        ),
      ),
    );
  }
}
