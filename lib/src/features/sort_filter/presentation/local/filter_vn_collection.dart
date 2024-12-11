import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
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
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/util/debouncer.dart';

// (*_ _)人 forgive me for using globals.
bool _showLangOptions = false;
bool _showdevStatOptions = false;
bool _showOriginOptions = false;
bool _showPlatformOptions = false;

class FilterVnCollection extends ConsumerStatefulWidget {
  const FilterVnCollection({super.key});

  @override
  ConsumerState<FilterVnCollection> createState() => _FilterVnCollectionState();
}

class _FilterVnCollectionState extends ConsumerState<FilterVnCollection> {
  final _debouncer = Debouncer(delay: Duration(milliseconds: 700));

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _refresh() async {
    _debouncer.call(() async {
      await ref.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _process(String filterName, var filterCode) async {
    final Map<String, dynamic> mappedFilter = ref.read(localFilterControllerProvider).toMap();

    // The type should be either list of strings or int, since minage will not be processed using
    // this method.
    mappedFilter[filterName] = mappedFilter[filterName].toSet().toList();

    if (mappedFilter[filterName].contains(filterCode)) {
      mappedFilter[filterName].remove(filterCode);
    } else {
      mappedFilter[filterName].add(filterCode);
    }

    // Updating the data
    ref.read(localFilterControllerProvider.notifier).importFilterData(FilterData.fromMap(mappedFilter));
    await _refresh();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _minageToFilter(int age) async {
    // Resetting the value if tapping the same button value.
    if (ref.read(localFilterControllerProvider).minage == age) {
      ref.read(localFilterControllerProvider.notifier).minage = 0;
      //
    } else {
      //
      ref.read(localFilterControllerProvider.notifier).minage = age;
    }

    await _refresh();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _resetFilter() async {
    ref.read(localFilterControllerProvider.notifier).reset();
    await _refresh();
    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(localFilterControllerProvider);

    final EdgeInsetsGeometry filterContentPadding = EdgeInsets.only(
      top: responsiveUI.own(0.015),
      left: responsiveUI.own(0.04),
      right: responsiveUI.own(0.04),
      bottom: responsiveUI.own(0.04),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Reset button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: responsiveUI.own(0.05)),
              alignment: Alignment.topLeft,
              child: Tooltip(
                message: 'Reset all filters',
                child: CustomButton(
                  content: ShadowText(' Reset '),
                  icon: Icons.refresh,
                  size: EdgeInsets.all(responsiveUI.own(0.018)),
                  gradientColor: [
                    App.themeColor.primary.withOpacity(0.85),
                    App.themeColor.secondary.withOpacity(0.65),
                  ],
                  onTap: _resetFilter,
                ),
              ),
            ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// All-ages | Adult
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: responsiveUI.own(0.06)),
              child: Material(
                elevation: 2.5,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.black.withOpacity(0.7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Wrap(
                    children: [
                      CustomButton(
                        content: ShadowText(" All-ages", fontSize: responsiveUI.own(0.03)),
                        tooltipMsg: "Only show VNs that has a minimum age below 18",
                        color: (filter.minage == 17)
                            ? const Color.fromARGB(255, 110, 200, 15)
                            : const Color.fromARGB(100, 110, 200, 15),
                        useButtonShadow: (filter.minage == 17),
                        radius: 0,
                        size: EdgeInsets.symmetric(
                          horizontal: responsiveUI.own(0.02),
                          vertical: responsiveUI.own(0.007),
                        ),
                        onTap: () async {
                          await _minageToFilter(17);
                        },
                      ),
                      CustomButton(
                        content: ShadowText("Adult-only ", fontSize: responsiveUI.own(0.03)),
                        tooltipMsg: "Only show VNs that has a minimum age of 18 and above",
                        color: (filter.minage == 18) ? Colors.red : Colors.red.withOpacity(0.45),
                        useButtonShadow: (filter.minage == 18),
                        radius: 0,
                        size: EdgeInsets.symmetric(
                          horizontal: responsiveUI.own(0.02),
                          vertical: responsiveUI.own(0.007),
                        ),
                        onTap: () async {
                          await _minageToFilter(18);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsiveUI.own(0.04)),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Language
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
                  )
              ],
            ),
          ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Development Status
        FilterItem(
          title: 'Development Status ',
          isOpened: _showdevStatOptions,
          onTap: () => setState(() => _showdevStatOptions = !_showdevStatOptions),
        ),
        if (_showdevStatOptions)
          Padding(
            padding: filterContentPadding,
            child: TransitionListContent(
              contentList: [
                for (int status in DEVELOPMENT_STATUS.keys)
                  GenerateDevRecordStatusOptions(
                    status: status,
                    func: () async => await _process(FilterableData.devstatus.name, status),
                  )
              ],
            ),
          ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Language Origin
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
// Platform
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
          )
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
