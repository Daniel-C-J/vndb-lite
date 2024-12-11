import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/remote/remote_sort_filter_repo.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/developers.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/search_filter_result_controller.dart';

class SearchDev extends ConsumerStatefulWidget {
  const SearchDev({super.key});

  @override
  ConsumerState<SearchDev> createState() => _SearchDevState();
}

class _SearchDevState extends ConsumerState<SearchDev> {
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

  Future<void> _process(Developer dev) async {
    final filter = ref.read(tempRemoteFilterControllerProvider);
    List<Developer> filterDev = filter.dev;

    // Remove duplication.
    filterDev = filterDev.toSet().toList();

    if (filterDev.contains(dev)) {
      filterDev.remove(dev);
    } else {
      filterDev.add(dev);
    }

    // Updating the data
    ref.read(tempRemoteFilterControllerProvider.notifier).copyWith(dev: filterDev);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _formatDevDataToWidget(var dev) {
    late final Developer developer;

    if (dev is Map<String, dynamic>) {
      developer = Developer.fromMap(dev);
    } else if (dev is Developer) {
      developer = dev;
    }

    return Container(
      margin: EdgeInsets.only(
        top: responsiveUI.own(0.025),
        right: responsiveUI.own(0.02),
      ),
      child: CustomLabel(
        useBorder: true,
        borderRadius: 10,
        isSelected: ref.watch(tempRemoteFilterControllerProvider).dev.contains(developer),
        onTap: () async => await _process(developer),
        children: [
          ShadowText(developer.name),
        ],
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
      child: ShadowText(
        "There's an error, maybe try again later?",
        color: Colors.red,
      ),
    );
  }

  Widget get _loadingSearch {
    return Padding(
      padding: EdgeInsets.only(top: responsiveUI.own(0.04)),
      child: SizedBox(
        height: responsiveUI.own(0.05),
        width: responsiveUI.own(0.05),
        child: CircularProgressIndicator(
          strokeWidth: responsiveUI.own(0.008),
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
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Selected dev options
        Padding(
          padding: EdgeInsets.only(top: responsiveUI.own(0.01)),
          child: Consumer(
            builder: (context, ref, child) {
              final filter = ref.watch(tempRemoteFilterControllerProvider);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (filter.dev.isNotEmpty) ShadowText('Selected:', fontSize: responsiveUI.own(0.0325)),
                  Wrap(
                    children: [for (Developer vnDev in filter.dev) _formatDevDataToWidget(vnDev)],
                  ),
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
                  onSubmitted: (_) async {
                    if (_textController.text.isEmpty) return;
                    ref.read(devSearchControllerProvider.notifier).state = _textController.text;
                  },
                  cursorColor: App.themeColor.tertiary,
                  style: styleText(fontSize: responsiveUI.own(0.036)),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: App.themeColor.tertiary.withOpacity(0.7),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: App.themeColor.secondary,
                      ),
                    ),
                    focusColor: App.themeColor.tertiary,
                    fillColor: App.themeColor.tertiary,
                    hintStyle: styleText(
                      fontSize: responsiveUI.normalSize,
                      color: Color.alphaBlend(
                        App.themeColor.tertiary.withOpacity(0.4),
                        App.themeColor.secondary,
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
                    ref.read(devSearchControllerProvider.notifier).state = _textController.text;
                  },
                  icon: Icon(
                    Icons.search,
                    color: App.themeColor.tertiary,
                    size: responsiveUI.own(0.05),
                  ),
                ),
              )
            ],
          ),
        ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Search results widget
        Consumer(builder: (context, ref, child) {
          final searchDev = ref.watch(devSearchControllerProvider);

          if (searchDev.isEmpty) {
            return const SizedBox.shrink();
          }

          return ref.watch(fetchDevelopersProvider(searchDev)).when(
            data: (response) {
              final results = response.data['results'];

              if (results.isEmpty) {
                return _emptyResult;
              }

              return Wrap(
                children: [
                  for (Map<String, dynamic> vnDev in results) _formatDevDataToWidget(vnDev),
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
        }),
      ],
    );
  }
}
