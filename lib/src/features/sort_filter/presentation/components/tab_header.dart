import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';

class FilterTabHeader extends ConsumerWidget {
  const FilterTabHeader({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: responsiveUI.own(0.125),
      child: GestureDetector(
        onVerticalDragEnd: (drag) {
          // A feature to close the bottom sheet by dragging the header down. Since this is a synthetic
          // header made to house a floating button.
          if (drag.localPosition.dy >= 1) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: App.themeColor.primary,
                boxShadow: [
                  BoxShadow(
                    color: App.themeColor.primary.withOpacity(0.7),
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(
                vertical: responsiveUI.own(0.06),
                horizontal: responsiveUI.own(1),
              ),
            ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tabs header
            Center(
              child: TabBar(
                dividerHeight: 0,
                indicatorWeight: 3,
                isScrollable: true,
                controller: tabController,
                tabAlignment: TabAlignment.center,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(
                  horizontal: responsiveUI.own(0.03),
                ),
                indicatorColor: App.themeColor.tertiary,
                labelStyle: styleText(fontSize: responsiveUI.normalSize),
                labelPadding: EdgeInsets.symmetric(
                  horizontal: responsiveUI.own(0.1),
                ),
                tabs: [
                  Tab(
                    child: ShadowText('Sort'),
                  ),
                  Tab(
                    child: ShadowText('Filter'),
                  )
                ],
              ),
            ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          ],
        ),
      ),
    );
  }
}
