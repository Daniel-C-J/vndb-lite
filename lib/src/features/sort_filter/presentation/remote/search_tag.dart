import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/util/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/remote/remote_sort_filter_repo.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/search_filter_result_controller.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';
import 'package:vndb_lite/src/util/context_shortcut.dart';

class SearchTag extends ConsumerStatefulWidget {
  const SearchTag({super.key});

  @override
  ConsumerState<SearchTag> createState() => _SearchTagState();
}

class _SearchTagState extends ConsumerState<SearchTag> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  //
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  //

  Future<void> _process(VnTag tag) async {
    final filter = ref.read(tempRemoteFilterControllerProvider);
    List<VnTag> filterTag = filter.tag;

    filterTag = filterTag.toSet().toList();

    if (filterTag.contains(tag)) {
      filterTag.remove(tag);
    } else {
      filterTag.add(tag);
    }

    // Updating the data
    ref
        .read(tempRemoteFilterControllerProvider.notifier)
        .importFilterData(filter.copyWith(tag: filterTag));
  }

  //
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  //

  Widget _formatTagDataToWidget(var tag) {
    late final VnTag vnTag;

    if (tag is Map<String, dynamic>) {
      vnTag = VnTag.fromMap(tag);
    } else if (tag is VnTag) {
      vnTag = tag;
    }

    return Container(
      margin: EdgeInsets.only(top: responsiveUI.own(0.025), right: responsiveUI.own(0.02)),
      child: CustomLabel(
        useBorder: true,
        borderRadius: 10,
        isSelected: ref.watch(tempRemoteFilterControllerProvider).tag.contains(vnTag),
        onTap: () async => await _process(vnTag),
        children: [ShadowText(vnTag.name!)],
      ),
    );
  }

  //
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  //

  Widget get _emptyResult {
    return Padding(
      padding: EdgeInsets.only(top: responsiveUI.own(0.02)),
      child: ShadowText("Nope, no result T_T "),
    );
  }

  Widget get _errorSearch {
    return Padding(
      padding: EdgeInsets.only(top: responsiveUI.own(0.02)),
      child: ShadowText("There's an error, maybe try again later?", color: Colors.red),
    );
  }

  Widget get _loadingSearch {
    return Padding(
      padding: EdgeInsets.only(top: responsiveUI.own(0.04)),
      child: SizedBox(
        height: responsiveUI.own(0.05),
        width: responsiveUI.own(0.05),
        child: CircularProgressIndicator(strokeWidth: responsiveUI.own(0.008)),
      ),
    );
  }

  //
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  //

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        // Selected tag options
        Padding(
          padding: EdgeInsets.only(top: responsiveUI.own(0.01)),
          child: Consumer(
            builder: (context, ref, child) {
              final filter = ref.watch(tempRemoteFilterControllerProvider);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (filter.tag.isNotEmpty)
                    ShadowText('Selected:', fontSize: responsiveUI.own(0.0325)),
                  Wrap(children: [for (VnTag vnTag in filter.tag) _formatTagDataToWidget(vnTag)]),
                ],
              );
            },
          ),
        ),
        SizedBox(height: responsiveUI.own(0.025)),

        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        // Search input Widget
        Container(
          padding: EdgeInsets.only(left: responsiveUI.own(0.01)),
          height: responsiveUI.own(0.1),
          child: Wrap(
            children: [
              SizedBox(
                height: responsiveUI.own(0.1),
                width: responsiveUI.own(0.3),
                child: TextField(
                  controller: _textController,
                  onSubmitted: (_) {
                    if (_textController.text.isEmpty) return;
                    ref.read(tagSearchControllerProvider.notifier).state = _textController.text;
                  },
                  cursorColor: kColor(context).tertiary,
                  style: styleText(fontSize: responsiveUI.own(0.036)),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: kColor(context).tertiary.withOpacity(0.7),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: kColor(context).secondary),
                    ),
                    focusColor: kColor(context).tertiary,
                    fillColor: kColor(context).tertiary,
                    hintStyle: styleText(
                      fontSize: responsiveUI.normalSize,
                      color: Color.alphaBlend(
                        kColor(context).tertiary.withOpacity(0.4),
                        kColor(context).secondary,
                      ),
                    ),
                  ),
                ),
              ),
              //
              // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              // Search Widget Icon
              Tooltip(
                message: 'Search',
                child: IconButton(
                  onPressed: () {
                    if (_textController.text.isEmpty) return;
                    ref.read(tagSearchControllerProvider.notifier).state = _textController.text;
                  },
                  icon: Icon(
                    Icons.search,
                    color: kColor(context).tertiary,
                    size: responsiveUI.own(0.05),
                  ),
                ),
              ),
            ],
          ),
        ),

        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        // Search results widget
        Consumer(
          builder: (context, ref, child) {
            final searchDev = ref.watch(tagSearchControllerProvider);

            if (searchDev.isEmpty) {
              return const SizedBox.shrink();
            }

            return ref
                .watch(fetchTagsProvider(searchDev))
                .when(
                  data: (response) {
                    final results = response.data['results'];

                    if (results.isEmpty) {
                      return _emptyResult;
                    }

                    return Wrap(
                      children: [
                        for (Map<String, dynamic> vnTag in results) _formatTagDataToWidget(vnTag),
                      ],
                    );
                  },
                  error: (err, st) {
                    return _errorSearch;
                  },
                  loading: () {
                    return _loadingSearch;
                  },
                );
          },
        ),
      ],
    );
  }
}
