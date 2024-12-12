import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/maintab_layout.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_appbar_controller.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/search/presentation/search_screen_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

class AppBarSearchButton extends ConsumerWidget {
  const AppBarSearchButton({super.key, this.additionalOnPress});

  final VoidCallback? additionalOnPress;

  bool get _showIconHighlight {
    if (ref_.read(localFilterControllerProvider).search.isNotEmpty && App.isInCollectionScreen) {
      return true;
    }

    return false;
  }

  String get _toolTipMessage {
    if (App.isInCollectionScreen) {
      return 'To search for tags or developers, start searching with either "dev:" or "tag:" without the quotes. '
          'For example: "dev: frontwing" or "tag: tomboy, childhood, pure love". \n\nNote: Currently cannot '
          'combine both keywords such as: "dev: nitro, tag: heroine with glasses".';
    }

    return 'Search';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: _toolTipMessage,
      highlightColor: Colors.white.withOpacity(0.25),
      onPressed: () async {
        if (additionalOnPress != null) additionalOnPress!();

        if (App.isInSearchScreen) {
          final searchQuery = textControllerSearch.text;
          ref.read(tempRemoteFilterControllerProvider.notifier).copyWith(search: searchQuery);
          ref.read(appliedRemoteFilterControllerProvider.notifier).copyWith(search: searchQuery);

          await ref.read(searchScreenControllerProvider.notifier).searchWithCurrentConf();
          //
        } else if (App.isInCollectionScreen) {
          // If already showing, then intitiate search.
          if (ref.read(showSearchTextFieldProvider)) {
            await ref.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
            return;
          }

          // If not showing yet, then refresh and show it.
          textControllerCollection.text = ref.read(localFilterControllerProvider).search;
          ref.read(showSearchTextFieldProvider.notifier).state = true;
        }
      },
      icon: Icon(
        Icons.search,
        color: App.themeColor.tertiary,
        size: responsiveUI.standardIcon,
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
