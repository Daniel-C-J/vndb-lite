import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/sort_item.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/util/debouncer.dart';

class SortVnCollection extends ConsumerWidget {
  const SortVnCollection({super.key});

  static final _debouncer = Debouncer(delay: Duration(milliseconds: 700));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(localSortControllerProvider);

    return Column(
      children: [
        for (String sortCode in LOCAL_SORTABLE_DATA.keys)
          SortItemTile(
            title: LOCAL_SORTABLE_DATA[sortCode]!.title,
            sortCode: sortCode,
            onTap: () async {
              // Only change the order of sort conf if the sort already chosen and tapped again.
              if (sort.sort == sortCode) {
                ref.read(localSortControllerProvider.notifier).reverse = !(sort.reverse ?? false);
                //
              } else {
                //
                ref.read(localSortControllerProvider.notifier).sort = sortCode;
                ref.read(localSortControllerProvider.notifier).reverse = false;
              }

              _debouncer.call(() async {
                await ref.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
              });
            },
          )
      ],
    );
  }
}
