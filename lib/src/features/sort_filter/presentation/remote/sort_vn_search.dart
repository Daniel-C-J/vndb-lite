import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/sort_item.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';

class SortVnSearch extends ConsumerWidget {
  const SortVnSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(tempRemoteSortControllerProvider);

    return Column(
      children: [
        for (String sortCode in REMOTE_SORTABLE_DATA.keys)
          SortItemTile(
            title: REMOTE_SORTABLE_DATA[sortCode]!.title,
            sortCode: sortCode,
            onTap: () async {
              // Only change the order of sort conf if the sort already chosen and tapped again.
              if (sort.sort == sortCode) {
                // Searchrank or None sort should not support reverse whatsoever, so just
                // go with the default reverse value, that is, false. (below)
                if (sortCode != SortableCode.searchrank.name) {
                  ref.read(tempRemoteSortControllerProvider.notifier).copyWith(
                        reverse: !(sort.reverse ?? false),
                      );
                }
                //
              } else {
                //
                ref.read(tempRemoteSortControllerProvider.notifier).copyWith(
                      reverse: false,
                      sort: sortCode,
                    );
              }
            },
            customIconLeading: (sortCode == SortableCode.searchrank.name) ? Icons.do_not_disturb : null,
            customTitleWidget: (sortCode == SortableCode.searchrank.name)
                ? Tooltip(
                    message: "Please don't empty/set an empty space query when using None sort, "
                        "otherwise it will return an error.",
                    child: Padding(
                      padding: EdgeInsets.only(top: responsiveUI.own(0.005), left: responsiveUI.own(0.015)),
                      child: Icon(
                        Icons.info_outline,
                        size: responsiveUI.own(0.045),
                        color: Color.alphaBlend(
                          Colors.black.withOpacity(0.2),
                          App.themeColor.secondary,
                        ),
                        shadows: [
                          BoxShadow(
                            blurRadius: 2,
                            color: App.themeColor.primary,
                          )
                        ],
                      ),
                    ),
                  )
                : null,
          )
      ],
    );
  }
}
