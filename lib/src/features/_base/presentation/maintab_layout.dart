import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:vndb_lite/src/common_widgets/generic_background.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/common_widgets/generic_snackbar.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/other_parts/main_scaffold_layout.dart';
import 'package:vndb_lite/src/features/_base/presentation/other_parts/navigation_rail_menu.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/tabs_sliver_appbar.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/search/presentation/search_result_controller.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_data_state.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme_state.dart';
import 'package:vndb_lite/src/features/theme/data/theme_data.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/tabs_bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/util/version_check/version_checker.dart';

// Intentionally made global to be easily accessing the value throughout the entire
// widget tree for specific and crucial use cases.
final TextEditingController textControllerCollection = TextEditingController();
final TextEditingController textControllerSearch = TextEditingController();
late TabController collectionTabController;

class MainTabLayout extends ConsumerStatefulWidget {
  const MainTabLayout({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainTabLayout> createState() {
    return _MainTabLayoutState();
  }
}

class _MainTabLayoutState extends ConsumerState<MainTabLayout> with TickerProviderStateMixin {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    collectionTabController = TabController(length: COLLECTION_STATUS_DATA.length, vsync: this);

    // Checks version at startup.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (ref.read(settingsDataStateProvider).autoUpdate) {
        VersionChecker.check(notify: (value) => _showVersionCheckSnackbar(success: value));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textControllerSearch.dispose();
    textControllerCollection.dispose();
    collectionTabController.dispose();
    super.dispose();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _showVersionCheckSnackbar({required bool success}) {
    GenericSnackBar(
      duration: const Duration(milliseconds: 3000),
      content: [
        Icon(
          (success) ? Icons.check_circle : Icons.error,
          color: (success) ? Colors.green : Colors.red,
          size: responsiveUI.snackbarIcon,
        ),
        SizedBox(width: responsiveUI.own(0.015)),
        ShadowText(
          (success) ? "App is Up-to-date" : "Failed checking new version",
          fontSize: responsiveUI.snackbarTxt,
        ),
      ],
    ).show();
  }
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // debugPrint('Current pixel : ${notification.metrics.pixels}');
    // debugPrint('Max scroll in pixel : ${notification.metrics.maxScrollExtent}');

    // This supports search screen lazy loading when user hit the bottom screen, the result continues.
    if (App.isInSearchScreen) {
      ref.read(searchResultControllerProvider.notifier).handleNextResult(notification);
    }

    return false;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final themeCode = ref.watch(settingsThemeStateProvider).appTheme;
    final theme = THEME_DATA[themeCode]!;

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Stack(
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        GenericBackground(
          imagePath: theme.backgroundImgPath,
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: (App.isInCollectionScreen) ? false : true,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
          body: Row(
            children: [
              // Exclusive landscape mode only
              if (isLandscape)
                TabsSideNavbar(
                  selectedIndex: widget.navigationShell.currentIndex,
                  onTap: _goToBranch,
                ),
              Expanded(
                child: NotificationListener(
                  onNotification: _handleScrollNotification,
                  child: NestedScrollView(
                    floatHeaderSlivers: true,
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      // Do not set to constant.
                      return <Widget>[
                        TabAppBar(),
                      ];
                    },
                    body: MainScaffoldBody(
                      navigationShell: widget.navigationShell,
                    ),
                  ),
                ),
              ),
            ],
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Exclusive portrait mode only
          bottomNavigationBar: Consumer(
            builder: (context, ref, child) {
              final isInMultiSelection = ref.watch(recordSelectedControllerProvider).isNotEmpty;

              // Disappear when in multiselection mode.
              if (isInMultiSelection) {
                return const SizedBox.shrink();
              }

              return TabsBottomNavbar(
                onlyProgressIndicator: isLandscape,
                selectedIndex: widget.navigationShell.currentIndex,
                scrollController: _scrollController,
                onTap: _goToBranch,
              );
            },
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
