import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_button.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/maintab_layout.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/refresh_button.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/routing/app_router.dart';
import 'package:vndb_lite/src/features/search/presentation/search_screen_controller.dart';

class VnDetailGeneralTags extends ConsumerStatefulWidget {
  const VnDetailGeneralTags({super.key, required this.p2});

  final VnDataPhase02 p2;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VnDetailGeneralTagsState();
}

class _VnDetailGeneralTagsState extends ConsumerState<VnDetailGeneralTags> {
  static const List<double> spoilerLimit = [0.6, 1.4, 2.0];

  // 0 ~ 2 the bigger, the more spoiler
  double _spoilerTag = spoilerLimit[0];

  bool _showFullTags = false;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Stream<List<Widget>> get _tags async* {
    final List<VnTag> rawTagList = widget.p2.tags ?? [];
    List<Widget> tagWidgets = [];

    if (rawTagList.isEmpty) yield tagWidgets;

    // Sort tags list based on its rating.
    rawTagList.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    for (VnTag tag in rawTagList) {
      // Get only the first 9 tags to be shown and add an additional widget.
      // (See below additional widget, why 9?)
      if (tagWidgets.length >= 10) {
        if (!_showFullTags) break;
      }

      if (tag.rating! >= 1 && tag.spoiler! <= _spoilerTag) {
        await Future.microtask(() => tagWidgets.add(_getTagWidget(tag)));
        yield tagWidgets;
      }
    }

    // Adds additional widget.
    if (tagWidgets.length >= 10) {
      // Removing the last if not showing full tags, eventually will be replaced by the additional widget.
      if (!_showFullTags) tagWidgets.removeLast();

      tagWidgets.add(
        CustomLabel(
          useBorder: false,
          onTap: () {
            setState(() {
              _showFullTags = !_showFullTags;
            });
          },
          children: [
            Icon(
              (_showFullTags) ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: responsiveUI.own(0.06),
              color: App.themeColor.tertiary,
            ),
          ],
        ),
      );

      yield tagWidgets;
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _getTagWidget(VnTag tag) {
    return Container(
      margin: EdgeInsets.only(
        right: responsiveUI.own(0.02),
        bottom: responsiveUI.own(0.02),
      ),
      child: Tooltip(
        message: 'Search for VNs with "${tag.name}" tag.',
        child: CustomLabel(
          onTap: () async {
            // Search Configurations to search the corresponding vn tag.
            final text = " ";
            textControllerSearch.text = text;

            final filter = Default.REMOTE_FILTER_CONF.copyWith(
              tag: [VnTag(id: tag.id, name: tag.name)],
              search: text,
              andOr: "and",
            );
            final sort = Default.REMOTE_SORT_CONF.copyWith(
              sort: SortableCode.rating.name,
              reverse: true,
            );

            ref.read(tempRemoteFilterControllerProvider.notifier).importFilterData(filter);
            ref.read(appliedRemoteFilterControllerProvider.notifier).importFilterData(filter);

            ref.read(tempRemoteSortControllerProvider.notifier).importSortData(sort);
            ref.read(appliedRemoteSortControllerProvider.notifier).importSortData(sort);

            await AppBarRefreshButton.tap();

            // Go to search screen.
            context.goNamed(AppRoute.search.name);

            // Initiate search.
            ref.read(searchScreenControllerProvider.notifier).searchWithCurrentConf();
          },
          useBorder: true,
          borderColor: (tag.spoiler! < spoilerLimit[0])
              ? Colors.transparent
              : (tag.spoiler! < spoilerLimit[1] ? Colors.yellow : Colors.red),
          children: [
            ShadowText('${tag.name} '),
            ShadowText(
              tag.rating!.toDouble().toStringAsFixed(1),
              color: App.themeColor.secondary,
              fontSize: responsiveUI.own(0.03),
            ),
          ],
        ),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _tagsSpoilerButton({
    required double spoilerLevel,
    required Color color,
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveUI.own(0.01),
      ),
      child: Opacity(
        opacity: (_spoilerTag == spoilerLevel) ? 1 : 0.7,
        child: CustomButton(
          onTap: () => setState(() {
            _spoilerTag = spoilerLevel;
          }),
          size: EdgeInsets.symmetric(
            horizontal: responsiveUI.own(0.025),
          ),
          color: (_spoilerTag == spoilerLevel) ? color : Colors.grey,
          content: ShadowText(title),
        ),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            ShadowText('Spoiler level: '),
            _tagsSpoilerButton(
              spoilerLevel: spoilerLimit[0],
              color: Colors.green,
              title: 'Low',
            ),
            _tagsSpoilerButton(
              spoilerLevel: spoilerLimit[1],
              color: const Color.fromARGB(255, 220, 200, 5),
              title: 'Medium',
            ),
            _tagsSpoilerButton(
              spoilerLevel: spoilerLimit[2],
              color: Colors.red,
              title: 'High',
            ),
          ],
        ),
        SizedBox(height: responsiveUI.own(0.025)),
        (widget.p2.tags == null || widget.p2.tags!.isEmpty)
            ? ShadowText('--')
            : StreamBuilder(
                stream: _tags,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShadowText('Loading...');
                  }

                  if (snapshot.hasError) {
                    return ShadowText('Something went wrong.', color: Colors.red);
                  }

                  return Wrap(children: snapshot.data);
                },
              ),
      ],
    );
  }
}
