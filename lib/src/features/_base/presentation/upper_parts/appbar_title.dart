import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/data/base_menu_sections.dart';
import 'package:vndb_lite/src/features/sync/presentation/auth_screen_controller.dart';

class AppbarTitle extends ConsumerWidget {
  const AppbarTitle({super.key});

  String get _activePageTitle {
    if (BASE_TAB_MENU_SECTIONS[App.currentRoute] == null) return '';
    return BASE_TAB_MENU_SECTIONS[App.currentRoute]!.title;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uId = ref.watch(authScreenControllerProvider);
    final userDidAuth = uId != null;

    return Stack(
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tab Appbar title
        Container(
          padding: (userDidAuth && App.isInCollectionScreen)
              ? EdgeInsets.only(top: responsiveUI.own(0.03))
              : const EdgeInsets.only(top: 0),
          child: ShadowText(
            _activePageTitle,
            color: App.themeColor.tertiary,
            fontSize: (userDidAuth && App.isInCollectionScreen)
                ? responsiveUI.own(0.050)
                : responsiveUI.own(0.0525),
          ),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Show username when user authenticated
        if (userDidAuth && App.isInCollectionScreen)
          Wrap(
            children: [
              ShadowText(
                uId.username,
                fontWeight: FontWeight.bold,
                fontSize: responsiveUI.own(0.034),
                color: App.themeColor.secondary,
              ),
              ShadowText(
                "'s",
                fontSize: responsiveUI.own(0.034),
              ),
            ],
          ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
