import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/home/data/preview_sections_data.dart';
import 'package:vndb_lite/src/features/home/domain/home_sections_model.dart';
import 'package:vndb_lite/src/features/home/presentation/section/section_content.dart';
import 'package:vndb_lite/src/features/home/presentation/section/section_header.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';
import 'package:vndb_lite/src/util/unique_valuekey.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getSectionTitle(String key) {
    return HOME_SCREEN_SECTIONS[key]!.title;
  }

  String? _getSectionLabelCode(String key) {
    return HOME_SCREEN_SECTIONS[key]!.labelCode;
  }

  FilterData? _getSectionFilter(String key) {
    return HOME_SCREEN_SECTIONS[key]!.filter;
  }

  HomePreviewSection _sectionDataOf(String sectionCode, int maxItem) {
    return HomePreviewSection(
      id: HOME_SCREEN_SECTIONS[sectionCode]!.id,
      title: _getSectionTitle(sectionCode),
      labelCode: _getSectionLabelCode(sectionCode),
      filter: _getSectionFilter(sectionCode),
      maxPreviewItem: maxItem,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsGeneralStateProvider);
    final homeArrangement = settings.homeSectionsArrangement;

    return Padding(
      padding: EdgeInsets.only(
        left: responsiveUI.own(0.045), // No safeArea in left since sideNavBar already handle it.
        right: measureSafeAreaOf(responsiveUI.own(0.045)),
      ),
      child: Column(
        children: [
          for (String sectionCode in homeArrangement)
            Column(
              mainAxisSize: MainAxisSize.min,
              key: uidKeyOf(sectionCode),
              children: [
                HomeSectionHeader(sectionData: _sectionDataOf(sectionCode, settings.maxPreviewItem)),
                HomeSectionContent(sectionData: _sectionDataOf(sectionCode, settings.maxPreviewItem)),
                SizedBox(height: responsiveUI.own(0.04)),
              ],
            ),
        ],
      ),
    );
  }
}
