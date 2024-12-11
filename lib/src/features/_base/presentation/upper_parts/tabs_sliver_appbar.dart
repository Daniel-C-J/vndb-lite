import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/appbar_title.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_appbar_controller.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_appbar_tabs.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_appbar.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';
import 'package:vndb_lite/src/features/home/presentation/home_appbar.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/multiselection_appbar.dart';
import 'package:vndb_lite/src/features/search/presentation/search_appbar.dart';

class TabAppBar extends ConsumerStatefulWidget {
  const TabAppBar({super.key});

  @override
  ConsumerState<TabAppBar> createState() => _TabAppBarState();
}

class _TabAppBarState extends ConsumerState<TabAppBar> {
  bool get _showTitle {
    final isInMultiselection = ref.watch(recordSelectedControllerProvider).isNotEmpty;
    final showTextField = ref.watch(showSearchTextFieldProvider);

    if (App.isInSearchScreen) return false;
    if (isInMultiselection) return false;
    if (showTextField && App.isInCollectionScreen) return false;
    if (App.isInOthersScreen) return true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isInMultiselection = ref.watch(recordSelectedControllerProvider).isNotEmpty;

    // Hides search text field when changing screen.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!App.isInCollectionScreen && mounted) {
        ref.read(showSearchTextFieldProvider.notifier).state = false;
      }
    });

    return SliverAppBar(
      elevation: 0,
      floating: true,
      toolbarHeight: responsiveUI.own(0.16),
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              App.themeColor.primary.withAlpha(250),
              App.themeColor.primary.withAlpha(150),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(160, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      snap: (App.isInCollectionScreen) ? false : true,
      pinned: (App.isInCollectionScreen) ? true : false,
      title: (_showTitle) ? AppbarTitle() : null,
      actions: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        if (App.isInHomeScreen) const HomeBarActions(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        if (App.isInSearchScreen) const SearchBarActions(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        if (!isInMultiselection && App.isInCollectionScreen) const CollectionBarActions(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        if (isInMultiselection && App.isInCollectionScreen) const MultiSelectionBarActions(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Collection tab bar
      bottom: (App.isInCollectionScreen) ? const CollectionAppbarTabs() : null,
    );
  }
}
