import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/common_widgets/generic_snackbar.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/other_parts/double_back_to_close.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/refresh_button.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/fab/multi_select_fab.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';

class MainScaffoldBody extends ConsumerStatefulWidget {
  const MainScaffoldBody({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScaffoldBody> createState() => _MainScaffoldBodyState();
}

class _MainScaffoldBodyState extends ConsumerState<MainScaffoldBody> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  bool get _showScrollbar {
    final remoteSearch = ref.read(appliedRemoteFilterControllerProvider).search;
    if (App.isInCollectionScreen) return true;
    if (App.isInSearchScreen && remoteSearch.isNotEmpty) {
      return true;
    }

    return false;
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
  Widget build(BuildContext context) {
    final scrollBarColor = App.themeColor.secondary.withOpacity(0.9);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Do not use const.
          DoubleBackToClose(),
          RawScrollbar(
            interactive: _showScrollbar,
            radius: const Radius.circular(12),
            minThumbLength: responsiveUI.own(0.1),
            crossAxisMargin: measureSafeAreaOf(responsiveUI.own(0.01)),
            thumbColor: (_showScrollbar) ? scrollBarColor : Colors.transparent,
            child: SmartRefresher(
              controller: _refreshController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              header: CupertinoSliverRefreshControl(
                refreshIndicatorExtent: responsiveUI.own(0.2),
                refreshTriggerPullDistance: responsiveUI.own(0.22),
                builder: (_, __, ___, ____, refreshIndicatorExtent) {
                  return LinearProgressIndicator(
                    minHeight: responsiveUI.own(0.012),
                    color: App.themeColor.primary,
                    backgroundColor: App.themeColor.secondary,
                  );
                },
                onRefresh: () async {
                  _showRefreshingSnackbar();
                  await AppBarRefreshButton.tap();
                },
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: responsiveUI.own(0.2),
                ),
                // The real content
                child: widget.navigationShell,
                //
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final isInMultiSelection = ref.watch(recordSelectedControllerProvider).isNotEmpty;

          if (isInMultiSelection) return const MultiSelectFab();
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
