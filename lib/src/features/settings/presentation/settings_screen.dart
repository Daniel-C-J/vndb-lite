import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_background.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme_state.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_data.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general.dart';
import 'package:vndb_lite/src/features/theme/data/theme_data.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showDataList = false;
  bool _showThemeList = false;
  bool _showVnPreviewList = false;

  @override
  Widget build(BuildContext context) {
    final themeCode = ref.watch(settingsThemeStateProvider).appTheme;
    final theme = THEME_DATA[themeCode]!;

    return Stack(
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        GenericBackground(
          imagePath: theme.backgroundImgPath,
          useGradientOverlay: true,
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
        Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            elevation: 8,
            toolbarHeight: responsiveUI.own(0.15),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    App.themeColor.primary.withAlpha(250),
                    App.themeColor.primary.withAlpha(150),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: responsiveUI.own(0.055),
              ),
              color: App.themeColor.tertiary,
            ),
            title: ShadowText(
              'Settings',
              fontSize: responsiveUI.own(0.0525),
            ),
          ),
          backgroundColor: App.themeColor.primary.withOpacity(0.25),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Body
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: measureSafeAreaOf(0),
              right: measureSafeAreaOf(0),
              bottom: responsiveUI.own(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Data list
                InkWell(
                  onTap: () {
                    setState(() => _showDataList = !_showDataList);
                  },
                  child: ListTile(
                    tileColor: App.themeColor.primary.withAlpha(50),
                    leading: Icon(
                      Icons.library_books,
                      color: App.themeColor.secondary,
                      size: responsiveUI.own(0.06),
                    ),
                    title: ShadowText('Data'),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsiveUI.own(0.045),
                      vertical: responsiveUI.own(0.005),
                    ),
                    dense: true,
                    trailing: Icon(
                      (!_showDataList) ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: App.themeColor.secondary,
                      size: responsiveUI.standardIcon,
                    ),
                  ),
                ),
                if (_showDataList) const SettingsData(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Theme
                InkWell(
                  onTap: () {
                    setState(() => _showThemeList = !_showThemeList);
                  },
                  child: ListTile(
                    tileColor: App.themeColor.primary.withAlpha(50),
                    leading: Icon(
                      Icons.settings_input_composite,
                      color: App.themeColor.secondary,
                      size: responsiveUI.own(0.06),
                    ),
                    title: ShadowText('Theme'),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsiveUI.own(0.045),
                      vertical: responsiveUI.own(0.005),
                    ),
                    dense: true,
                    trailing: Icon(
                      (!_showThemeList) ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: App.themeColor.secondary,
                      size: responsiveUI.standardIcon,
                    ),
                  ),
                ),
                if (_showThemeList) const SettingsTheme(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// General
                InkWell(
                  onTap: () {
                    setState(() => _showVnPreviewList = !_showVnPreviewList);
                  },
                  child: ListTile(
                    tileColor: App.themeColor.primary.withAlpha(50),
                    leading: Icon(
                      Icons.amp_stories,
                      color: App.themeColor.secondary,
                      size: responsiveUI.own(0.06),
                    ),
                    title: ShadowText('General'),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsiveUI.own(0.045),
                      vertical: responsiveUI.own(0.005),
                    ),
                    dense: true,
                    trailing: Icon(
                      (!_showVnPreviewList) ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: App.themeColor.secondary,
                      size: responsiveUI.standardIcon,
                    ),
                  ),
                ),
                if (_showVnPreviewList) const SettingsGeneral(),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
              ],
            ),
          ),
        )
      ],
    );
  }
}
