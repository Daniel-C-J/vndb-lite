import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';

part 'stat_chart_controller.g.dart';

@riverpod
class SearchChartSpinController extends _$SearchChartSpinController {
  int _spinTimes = 0;

  @override
  double build() {
    return 0;
  }

  void handlePan(DragUpdateDetails details) {
    final context = NavigationService.currentContext;
    final Offset center = Offset(MediaQuery.sizeOf(context).width / 2, MediaQuery.sizeOf(context).height / 2);
    final Offset offset = details.globalPosition;

    // Calculate the angle in radians
    final double radians = math.atan2(offset.dy - center.dy, offset.dx - center.dx);

    // Reducing the numbers of pie chart degree before it got rendered.
    state = state % 360;

    if (state % 360 > 359) {
      _spinTimes++;
    } else if (state % 360 < 1) {
      _spinTimes--;
    }

    // Convert radians to degrees
    state = (_spinTimes * 360) + (radians * (180 / math.pi));

    // debugPrint("Angle: $state degrees");
  }
}
