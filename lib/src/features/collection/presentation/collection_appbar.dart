import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/appbar_searchfield.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/refresh_button.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/search_button.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/filter_button.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_appbar_controller.dart';

class CollectionBarActions extends ConsumerWidget {
  const CollectionBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTextField = ref.watch(showSearchTextFieldProvider);

    final content = Row(
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        if (showTextField) const Expanded(child: AppbarSearchfield()),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        // if (showTextField) const GenericDivider(), // Dont like it...
        if (!showTextField) const AppBarSearchButton(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        const AppBarSortFilterButton(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        const AppBarRefreshButton(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );

    if (showTextField) return Expanded(child: content);
    return content;
  }
}
