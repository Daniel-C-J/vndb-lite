import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/maintab_layout.dart';
import 'package:vndb_lite/src/features/home/domain/home_sections_model.dart';
import 'package:vndb_lite/src/features/search/presentation/search_screen_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/remote/remote_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/sync/presentation/auth_screen_controller.dart';
import 'package:vndb_lite/src/routing/app_router.dart';

class HomeSectionHeader extends ConsumerWidget {
  const HomeSectionHeader({
    super.key,
    required this.sectionData,
  });

  final HomePreviewSection sectionData;

  bool get _titleIsCollection {
    return sectionData.title.toLowerCase().contains('collection');
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void seeMore(WidgetRef ref, {bool isCollection = false, String? sortBy, FilterData? filter}) async {
    if (isCollection) {
      NavigationService.currentContext.goNamed(AppRoute.collection.name);
      return;
    }

    if (sortBy != null) {
      ref.read(tempRemoteSortControllerProvider.notifier).copyWith(sort: sortBy);
      ref.read(appliedRemoteSortControllerProvider.notifier).copyWith(sort: sortBy);
    }

    if (filter != null) {
      ref.read(tempRemoteFilterControllerProvider.notifier).importFilterData(filter);
      ref.read(appliedRemoteFilterControllerProvider.notifier).importFilterData(filter);
    }

    textControllerSearch.text = ' ';
    ref.read(tempRemoteFilterControllerProvider.notifier).copyWith(search: ' ');
    ref.read(appliedRemoteFilterControllerProvider.notifier).copyWith(search: ' ');

    await ref.read(searchScreenControllerProvider.notifier).searchWithCurrentConf();

    NavigationService.currentContext.goNamed(AppRoute.search.name);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget _authedCollectionTitleOf(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            ShadowText(
              username,
              color: App.themeColor.secondary.withAlpha(200),
              fontSize: responsiveUI.own(0.046),
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Color.alphaBlend(
                    Colors.black.withOpacity(0.5),
                    App.themeColor.primary,
                  ),
                  blurRadius: 8,
                )
              ],
            ),
            ShadowText("'s", fontSize: responsiveUI.own(0.046)),
          ],
        ),
        ShadowText(
          "Latest Collection",
          fontSize: responsiveUI.catgTitle,
          color: App.themeColor.tertiary,
          shadows: [Shadow(color: App.themeColor.secondary, blurRadius: 5)],
        ),
      ],
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uId = ref.watch(authScreenControllerProvider);
    final userDidAuth = uId != null;

    return Padding(
      padding: (userDidAuth && _titleIsCollection)
          ? EdgeInsets.only(bottom: responsiveUI.own(0.025), top: responsiveUI.own(0.025))
          : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (userDidAuth && _titleIsCollection)
              ? _authedCollectionTitleOf(uId.username)
              : ShadowText(
                  sectionData.title,
                  fontSize: responsiveUI.catgTitle,
                  color: App.themeColor.tertiary,
                  shadows: [Shadow(color: App.themeColor.secondary, blurRadius: 5)],
                ),
          TextButton(
            onPressed: () {
              seeMore(
                ref,
                filter: sectionData.filter,
                sortBy: sectionData.labelCode,
                isCollection: sectionData.labelCode == SortableCode.collection.name,
              );
            },
            child: Text(
              'See more >',
              style: TextStyle(
                fontSize: responsiveUI.normalSize,
                decoration: TextDecoration.underline,
                color: App.themeColor.secondary,
                decorationColor: App.themeColor.secondary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
