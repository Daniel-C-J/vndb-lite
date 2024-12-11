import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/generic_local_empty_content.dart';
import 'package:vndb_lite/src/common_widgets/masonry_grid.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/vn_item_grid_.dart';

class CollectionContent extends ConsumerWidget {
  const CollectionContent({super.key, required this.content});

  final List<VnItemGrid> content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsGeneralStateProvider);

    return Stack(
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.65),
        (content.isEmpty)
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(responsiveUI.own(0.1)),
                  child: GenericLocalEmptyWidget(),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.015)),
                child: MasonryGrid(
                  staggered: true,
                  mainAxisSpacing: responsiveUI.own(0.035),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  column: (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? settings.maxItemPerRowPortrait
                      : settings.maxItemPerRowLandscape,
                  children: content,
                ),
              ),
      ],
    );
  }
}
