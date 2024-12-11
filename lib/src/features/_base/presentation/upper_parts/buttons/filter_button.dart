import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/bottom_sheet_collection.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/bottom_sheet_search.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';

class AppBarSortFilterButton extends ConsumerStatefulWidget {
  const AppBarSortFilterButton({super.key});

  @override
  ConsumerState<AppBarSortFilterButton> createState() => _AppBarSortFilterButtonState();
}

class _AppBarSortFilterButtonState extends ConsumerState<AppBarSortFilterButton> {
  void _postRemoteFilter() {
    final appliedFilter = ref.read(appliedRemoteFilterControllerProvider);

    // When closing the bottom sheet without applying, then the temp filter will be overridden with
    // the current applied one.
    ref.read(tempRemoteFilterControllerProvider.notifier).importFilterData(appliedFilter);
  }

  void _postLocalFilter() {
    // Do something?
  }

  bool get _showIconHighlight {
    // If it is not the same as the default filter data, meaning that there is a change, then
    // show iconHighlight.
    if (App.isInCollectionScreen) {
      // Since we only focus on filters other than searchQuery.
      final localFilterWithoutSearch =
          ref.read(localFilterControllerProvider).copyWith(search: Default.LOCAL_FILTER_CONF.search);

      if (localFilterWithoutSearch != Default.LOCAL_FILTER_CONF) {
        return true;
      }
    }

    if (App.isInSearchScreen) {
      // Since we only focus on filters other than searchQuery.
      final remoteFilterWithoutSearch =
          ref.read(appliedRemoteFilterControllerProvider).copyWith(search: Default.REMOTE_FILTER_CONF.search);

      if (remoteFilterWithoutSearch != Default.REMOTE_FILTER_CONF) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Sort & Filter',
      highlightColor: Colors.white.withOpacity(0.25),
      onPressed: () async {
        return await showModalBottomSheet(
          context: NavigationService.currentContext,
          isScrollControlled: true,
          shape: (App.isInSearchScreen)
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                )
              : null,
          builder: (ctx) {
            if (App.isInSearchScreen) return BottomSheetSearch();
            return BottomSheetCollection();
          },
        ).then((_) {
          if (App.isInSearchScreen) _postRemoteFilter();
          if (App.isInCollectionScreen) _postLocalFilter();

          setState(() {});
        });
      },
      icon: Icon(
        Icons.filter_list,
        size: responsiveUI.standardIcon,
        color: App.themeColor.tertiary,
        shadows: (_showIconHighlight)
            ? [
                Shadow(
                  color: Color.alphaBlend(
                    App.themeColor.tertiary.withOpacity(0.8),
                    App.themeColor.secondary,
                  ),
                  blurRadius: 10,
                )
              ]
            : null,
      ),
    );
  }
}
