import 'package:flutter/material.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';

const int statusBarHeightApprox = 50;

bool get isSafeAreaNeccessary {
  final BuildContext context = NavigationService.currentContext;
  final double viewPaddingTop = MediaQuery.of(context).viewPadding.top;
  final double topNotchAreaPadding = WidgetsBinding.instance.platformDispatcher.views.first.padding.top;

  return (topNotchAreaPadding - viewPaddingTop) >= statusBarHeightApprox;
}

/// This function is used as an artificial [SafeArea] widget, which provides more flexibility
/// on how to handle SafeArea throughout the app design.
double measureSafeAreaOf(double originalSize) {
  final BuildContext context = NavigationService.currentContext;
  final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  final double viewPaddingTop = MediaQuery.of(context).viewPadding.top;
  final double topNotchAreaPadding = WidgetsBinding.instance.platformDispatcher.views.first.padding.top;

  // Checks whether there is actually a need for a safeArea (E.g the camera padding in modern phones)
  final bool needsToResize = (topNotchAreaPadding - viewPaddingTop) >= statusBarHeightApprox;

  // Should not be negative, if negative will return just only the topNotchAreaPadding.
  final bool isNotNegative = originalSize > topNotchAreaPadding;

  if (isPortrait || !needsToResize) return originalSize;
  if (needsToResize && isNotNegative) return originalSize - topNotchAreaPadding;

  // Returns raw safeArea.
  return topNotchAreaPadding;
}
