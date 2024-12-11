import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/common_widgets/custom_label.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/refresh_button.dart';
import 'package:vndb_lite/src/features/settings/presentation/components/settings_list_theme_selection.dart';
import 'package:vndb_lite/src/features/settings/presentation/dialog/settings_dialog.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme_state.dart';
import 'package:vndb_lite/src/features/theme/data/theme_data.dart';
import 'package:vndb_lite/src/app.dart';

class SettingsTheme extends ConsumerStatefulWidget {
  const SettingsTheme({super.key});

  @override
  ConsumerState<SettingsTheme> createState() => _SettingsDataState();
}

class _SettingsDataState extends ConsumerState<SettingsTheme> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();

    _offsetAnimation = _animationController
        .drive(CurveTween(curve: Curves.easeInOut))
        .drive(Tween<Offset>(begin: const Offset(0, -0.5), end: const Offset(0, 0)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _refreshApp() async {
    await AppBarRefreshButton.tap();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _changeTheme() async {
    await showSettingsDialog(
      title: 'Change App Theme',
      content: ListThemeSelection(refresh: _refreshApp),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _changeFontSize() async {
    double tempFontSize = ref.read(settingsThemeStateProvider).fontSize;

    await showSettingsDialog(
      title: 'Change Font Size',
      yesOrNo: true,
      yesFunction: () async {
        ref.read(settingsThemeStateProvider.notifier).fontSize = tempFontSize;
        await _refreshApp();
      },
      content: StatefulBuilder(
        builder: (ctx, setState) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: responsiveUI.own(0.05),
                  left: responsiveUI.own(0.05),
                  bottom: responsiveUI.own(0.03),
                ),
                child: ShadowText(
                  "You would have to restart the app for the configured change to take effect.",
                ),
              ),
              SizedBox(height: responsiveUI.own(0.03)),
              // Text as a countermeasure.
              ShadowText(
                '"VN stands for Visual Novel."',
                fontSize: responsiveUI.own(
                  Default.FONT_SIZE_CONF + tempFontSize,
                  withCustom: false,
                ),
              ),
              SliderTheme(
                data: SliderThemeData(tickMarkShape: SliderTickMarkShape.noTickMark),
                child: Slider(
                  value: tempFontSize,
                  divisions: 5,
                  min: -0.006,
                  max: 0.004,
                  onChanged: (val) {
                    setState(() => tempFontSize = val);
                  },
                  thumbColor: App.themeColor.secondary,
                  activeColor: Color.alphaBlend(
                    App.themeColor.tertiary.withOpacity(0.4),
                    App.themeColor.primary,
                  ),
                  label: _getUserFriendlyFontSize(tempFontSize),
                ),
              )
            ],
          );
        },
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  String _getUserFriendlyFontSize(double fontSize) {
    if (fontSize <= -0.006) return "Tiny";
    if (fontSize <= -0.004) return "Smaller";
    if (fontSize <= -0.002) return "Small";
    if (fontSize <= 0) return "Medium";
    if (fontSize <= 0.002) return "Big";
    return "Bigger";
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsThemeStateProvider);

    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _animationController.drive(CurveTween(curve: Curves.easeInToLinear)),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(responsiveUI.own(0.04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Font Size

              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _changeFontSize(),
                children: [
                  ShadowText('Font size: '),
                  ShadowText(
                    _getUserFriendlyFontSize(settings.fontSize),
                    fontSize: responsiveUI.normalSize,
                    color: App.themeColor.tertiary.withAlpha(180),
                  ),
                ],
              ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Change theme
              SizedBox(height: responsiveUI.own(0.03)),
              CustomLabel(
                useBorder: true,
                borderRadius: 12,
                isSelected: false,
                borderColor: App.themeColor.secondary,
                padding: EdgeInsets.all(responsiveUI.own(0.02)),
                onTap: () async => await _changeTheme(),
                children: [
                  ShadowText('Theme: '),
                  ShadowText(
                    THEME_DATA[settings.appTheme]!.themeName,
                    fontWeight: FontWeight.bold,
                    fontSize: responsiveUI.normalSize,
                    color: App.themeColor.secondary,
                  ),
                ],
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            ],
          ),
        ),
      ),
    );
  }
}
