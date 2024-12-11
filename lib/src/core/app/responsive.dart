import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_theme_state.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

// Global singleton
final responsiveUI = _ResponsiveUI();

/// A class that measures the size based on screen width or height based on the orientation.
class _ResponsiveUI {
  double get normalSize => own(Default.FONT_SIZE_CONF);
  double get catgTitle => own(0.0425);
  double get standardIcon => own(0.065);
  double get snackbarTxt => own(0.0315);
  double get snackbarIcon => own(0.0485);

  double own(double size, {bool withCustom = true}) {
    final BuildContext context = NavigationService.currentContext;
    final Size screenSize = MediaQuery.sizeOf(context);

    final double customFontSize = (withCustom) ? getCustomFontSize() : 0;
    final double responsiveSize = getResponsiveSize(size, customFontSize);

    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? screenSize.width * responsiveSize
        : screenSize.height * responsiveSize;
  }

  double getCustomFontSize([WidgetRef? ref]) {
    final tempRef = ref ?? ref_; // Uses emergency if needed.
    return tempRef.read(settingsThemeStateProvider).fontSize;
  }

  double getResponsiveSize(double size, double customFontSize) {
    // Prevent minus value.
    if ((size + customFontSize) < 0) return 0.001;

    return (size + customFontSize);
  }
}
