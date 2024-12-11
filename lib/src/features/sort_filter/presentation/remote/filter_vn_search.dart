import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/devstatus_data.dart';
import 'package:vndb_lite/src/features/sort_filter/data/filterable_data.dart';
import 'package:vndb_lite/src/features/sort_filter/data/languages_data.dart';
import 'package:vndb_lite/src/features/sort_filter/data/platform_code_data.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/filter_item.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/generate_dev_status.options.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/generate_flag_options.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/generate_platform_options.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/list_content_animation.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/search_dev.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/search_tag.dart';

// (*_ _)人 forgive me for using globals.
bool _showLangOptions = false;
bool _showDevStatOptions = false;
bool _showDevOptions = false;
bool _showOriginOptions = false;
bool _showPlatformOptions = false;
bool _showTagOptions = false;

class FilterVnSearch extends ConsumerStatefulWidget {
  const FilterVnSearch({super.key});

  @override
  ConsumerState<FilterVnSearch> createState() => _SortVnSearchState();
}

class _SortVnSearchState extends ConsumerState<FilterVnSearch> {
  Future<void> _process(String filterName, var filterCode) async {
    final mappedFilter = ref.read(tempRemoteFilterControllerProvider).toMap();

    // The type should be either list of strings or int, since minage will not be processed using
    // this method.
    mappedFilter[filterName] = mappedFilter[filterName].toSet().toList();

    if (mappedFilter[filterName].contains(filterCode)) {
      mappedFilter[filterName].remove(filterCode);
    } else {
      mappedFilter[filterName].add(filterCode);
    }

    // Updating the data
    final newFilter = FilterData.fromMap(mappedFilter);
    ref.read(tempRemoteFilterControllerProvider.notifier).importFilterData(newFilter);
    setState(() {});
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(tempRemoteFilterControllerProvider);

    final EdgeInsetsGeometry filterContentPadding = EdgeInsets.only(
      top: responsiveUI.own(0.015),
      left: responsiveUI.own(0.04),
      right: responsiveUI.own(0.04),
      bottom: responsiveUI.own(0.04),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveUI.own(0.042),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShadowText('Visual Novel'),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// And/Or
              Container(
                margin: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.02)),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Wrap(
                      children: [
                        CustomButton(
                          content: ShadowText("Must"),
                          radius: 0,
                          color: (filter.andOr == "and")
                              ? App.themeColor.secondary.withOpacity(0.8)
                              : App.themeColor.secondary.withOpacity(0.45),
                          size: EdgeInsets.symmetric(
                            horizontal: responsiveUI.own(0.03),
                            vertical: responsiveUI.own(0.005),
                          ),
                          useButtonShadow: (filter.andOr == "and"),
                          onTap: () {
                            ref.read(tempRemoteFilterControllerProvider.notifier).copyWith(andOr: "and");
                          },
                        ),
                        CustomButton(
                          content: ShadowText("May"),
                          radius: 0,
                          color: (filter.andOr == "or")
                              ? App.themeColor.secondary.withOpacity(0.8)
                              : App.themeColor.secondary.withOpacity(0.45),
                          size: EdgeInsets.symmetric(
                            horizontal: responsiveUI.own(0.03),
                            vertical: responsiveUI.own(0.005),
                          ),
                          useButtonShadow: (filter.andOr == "or"),
                          onTap: () {
                            ref.read(tempRemoteFilterControllerProvider.notifier).copyWith(andOr: "or");
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ShadowText('have the following: '),
            ],
          ),
        ),
        SizedBox(height: responsiveUI.own(0.04)),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Languages
        FilterItem(
          title: 'Available Languages ',
          isOpened: _showLangOptions,
          onTap: () => setState(() => _showLangOptions = !_showLangOptions),
        ),
        if (_showLangOptions)
          Padding(
            padding: filterContentPadding,
            child: TransitionListContent(
              contentList: [
                for (String langCode in FILTERABLE_AVAILABLE_LANGUAGE_CODE)
                  GenerateFlagOptions(
                    languageCode: langCode,
                    identifier: 'availLang',
                    func: () async => await _process(FilterableData.lang.name, langCode),
                  ),
              ],
            ),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Developer

        FilterItem(
          title: 'Developer ',
          isOpened: _showDevOptions,
          onTap: () => setState(() => _showDevOptions = !_showDevOptions),
        ),
        if (_showDevOptions)
          Padding(
            padding: filterContentPadding,
            // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
            child: TransitionListContent(contentList: [SearchDev()]),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Development Status
        FilterItem(
          title: 'Development Status ',
          isOpened: _showDevStatOptions,
          onTap: () => setState(() => _showDevStatOptions = !_showDevStatOptions),
        ),

        if (_showDevStatOptions)
          Padding(
            padding: filterContentPadding,
            child: TransitionListContent(
              contentList: [
                for (int status in DEVELOPMENT_STATUS.keys)
                  if (status != -1)
                    GenerateDevRecordStatusOptions(
                      status: status,
                      func: () async => await _process(FilterableData.devstatus.name, status),
                    )
              ],
            ),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Origin language
        FilterItem(
          title: 'Origin ',
          isOpened: _showOriginOptions,
          onTap: () => setState(() => _showOriginOptions = !_showOriginOptions),
        ),

        if (_showOriginOptions)
          Padding(
            padding: filterContentPadding,
            child: TransitionListContent(
              contentList: [
                for (String langCode in FILTERABLE_ORIGIN_LANGUAGE_CODE)
                  GenerateFlagOptions(
                    languageCode: langCode,
                    identifier: 'originLang',
                    func: () async => await _process(FilterableData.olang.name, langCode),
                  )
              ],
            ),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Platforms
        FilterItem(
          title: 'Platforms ',
          isOpened: _showPlatformOptions,
          onTap: () => setState(() => _showPlatformOptions = !_showPlatformOptions),
        ),
        if (_showPlatformOptions)
          Padding(
            padding: filterContentPadding,
            child: TransitionListContent(
              contentList: [
                for (String platfCode in PLATFORM_DATA.keys)
                  GeneratePlatformOptions(
                    platformCode: platfCode,
                    platformName: PLATFORM_DATA[platfCode]!,
                    func: () async => await _process(FilterableData.platform.name, platfCode),
                  )
              ],
            ),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tags
        FilterItem(
          title: 'Tags ',
          isOpened: _showTagOptions,
          onTap: () => setState(() => _showTagOptions = !_showTagOptions),
        ),
        if (_showTagOptions)
          Padding(
            padding: filterContentPadding,
            // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
            child: TransitionListContent(contentList: [SearchTag()]),
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
