import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/data/base_menu_sections.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/_base/presentation/other_parts/navigation_rail_menu.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';

class TabsBottomNavbar extends StatelessWidget {
  const TabsBottomNavbar({
    super.key,
    required this.scrollController,
    required this.selectedIndex,
    required this.onTap,
    this.onlyProgressIndicator = false,
  });

  final ScrollController scrollController;
  final int selectedIndex;
  final void Function(int)? onTap;
  final bool onlyProgressIndicator;

  static final double heightBottomNav = responsiveUI.own(0.18);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!onlyProgressIndicator)
          ScrollToHide(
            height: heightBottomNav,
            scrollController: scrollController,
            hideDirection: Axis.vertical,
            child: Container(
              height: heightBottomNav,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    App.themeColor.primary.withAlpha(140),
                    App.themeColor.primary.withAlpha(220),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(150, 0, 0, 0),
                    spreadRadius: 2,
                    blurRadius: 6,
                  )
                ],
              ),
              child: BottomNavigationBar(
                items: [
                  for (MapEntry<String, dynamic> menu in BASE_TAB_MENU_SECTIONS.entries)
                    BottomNavigationBarItem(
                      icon: Icon(
                        menu.value.icon,
                        size: responsiveUI.standardIcon,
                      ),
                      label: menu.value.title,
                    ),
                ],
                onTap: onTap,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedLabelStyle: styleText(
                  fontSize: responsiveUI.normalSize,
                  fontWeight: FontWeight.bold,
                  color: App.themeColor.tertiary,
                ),
                unselectedLabelStyle: styleText(
                  fontSize: responsiveUI.normalSize,
                  color: App.themeColor.tertiary,
                ),
                currentIndex: selectedIndex,
                selectedFontSize: responsiveUI.normalSize,
                unselectedFontSize: responsiveUI.normalSize,
                selectedItemColor: App.themeColor.secondary,
                unselectedItemColor: App.themeColor.secondary.withAlpha(120),
              ),
            ),
          ),
        Consumer(
          builder: (context, ref, child) {
            if (ref.watch(bottomProgressIndicatorProvider)) {
              final safeArea = (isSafeAreaNeccessary) ? measureSafeAreaOf(TabsSideNavbar.widthSideNav) : 0.0;

              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: responsiveUI.own(0.01),
                child: Padding(
                  padding: (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? EdgeInsets.zero
                      : EdgeInsets.only(
                          left: TabsSideNavbar.widthSideNav + safeArea,
                        ),
                  child: LinearProgressIndicator(
                    backgroundColor: App.themeColor.secondary,
                    color: App.themeColor.primary,
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
