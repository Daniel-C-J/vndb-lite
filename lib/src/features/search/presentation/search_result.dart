import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/masonry_grid.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/search/presentation/search_result_controller.dart';
import 'package:vndb_lite/src/features/search/presentation/search_screen_controller.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';

/// A class to display pure search result (No error, no loading).
/// The heart of this class is searchResultControllerProvider that provides this class's content.
class SearchResult extends ConsumerStatefulWidget {
  const SearchResult({super.key});

  @override
  ConsumerState<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends ConsumerState<SearchResult> {
  void _forceUpdateUI() {
    SchedulerBinding.instance.addPersistentFrameCallback((_) {
      if (!mounted) return;
      ref.read(searchResultNotifierProvider.notifier).ring();
      ref.read(searchResultNotifierProvider.notifier).end();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsGeneralStateProvider);
    final searchResult = ref.watch(searchResultControllerProvider);
    final searchNotify = ref.watch(searchResultNotifierProvider);

    // To forcefully update the widget
    if (searchNotify && mounted) {
      _forceUpdateUI();
    }

    return Padding(
      padding: EdgeInsets.only(top: responsiveUI.own(0.04)),
      child: MasonryGrid(
        staggered: true,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSpacing: responsiveUI.own(0.03),
        column: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? settings.maxItemPerRowPortrait
            : settings.maxItemPerRowLandscape,
        children: searchResult,
      ),
    );
  }
}
