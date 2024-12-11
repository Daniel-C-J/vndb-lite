import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/other_parts/navigation_rail_menu.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/multiselection/record_selected_controller.dart';

class GenericSnackBar {
  const GenericSnackBar({
    required this.content,
    this.duration,
  });

  final List<Widget> content;
  final Duration? duration;

  static const int snackBarDurationInMilliseconds = 4000;

  static void hide() {
    final BuildContext context = NavigationService.currentContext;
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  static SnackBar buildSnackBar({required List<Widget> children, Duration? duration}) {
    final BuildContext context = NavigationService.currentContext;
    final isEmpty = children.isEmpty;

    return SnackBar(
      key: ValueKey("snackbar"),
      elevation: 0,
      clipBehavior: Clip.none,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      closeIconColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      duration: duration ??
          const Duration(
            seconds: snackBarDurationInMilliseconds,
          ),
      content: Padding(
        padding: (MediaQuery.of(context).orientation == Orientation.portrait || !App.isInMainTab)
            ? EdgeInsets.zero
            : EdgeInsets.only(left: TabsSideNavbar.widthSideNav),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 0,
              clipBehavior: Clip.none,
              margin: EdgeInsets.zero,
              color: Colors.transparent,
              child: Consumer(
                builder: (context, ref, child) {
                  // Only quits when in multiselection and hitting back button.
                  final isInMultiselection = ref.watch(recordSelectedControllerProvider).isNotEmpty;

                  if (isInMultiselection) {
                    // Deactivating multiSelectionmode.
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      ref.invalidate(recordSelectedControllerProvider);
                    });
                  }

                  return Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.565),
                    padding: EdgeInsets.symmetric(
                      vertical: responsiveUI.own(0.025),
                      horizontal: responsiveUI.own(0.035),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      gradient: (isEmpty || isInMultiselection)
                          ? null
                          : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                App.themeColor.primary.withAlpha(120),
                                App.themeColor.primary.withAlpha(200),
                              ],
                            ),
                      boxShadow: (isEmpty || isInMultiselection)
                          ? null
                          : const [
                              BoxShadow(
                                color: Color.fromARGB(100, 0, 0, 0),
                                spreadRadius: 2,
                                blurRadius: 6,
                              )
                            ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (isInMultiselection) ? [] : children,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ScaffoldFeatureController show({bool stacked = false}) {
    final BuildContext context = NavigationService.currentContext;

    if (!stacked) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }

    return ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(
        children: content,
        duration: duration,
      ),
    );
  }
}
