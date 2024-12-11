import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/chart/application/chart_service.dart';
import 'package:vndb_lite/src/features/chart/data/search_chart._data.dart';
import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/features/chart/presentation/stat_chart_controller.dart';

class VNDBStatsChart extends ConsumerStatefulWidget {
  const VNDBStatsChart({super.key});

  @override
  ConsumerState<VNDBStatsChart> createState() => _VndbStatChartState();
}

class _VndbStatChartState extends ConsumerState<VNDBStatsChart> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final double standardPieChartRadius = responsiveUI.own(0.09);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();

    // Initialization of chart statistics value, depending on either local downloaded/hardcoded value, or
    // remote updated value.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(getStatsChartProvider);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  PieChartSectionData _pieData(String valueType) {
    return PieChartSectionData(
      showTitle: false,
      gradient: LinearGradient(
        colors: [
          searchChartStatsData[valueType]!.color,
          App.themeColor.secondary.withOpacity(0.6),
        ],
      ),
      value: searchChartStatsData[valueType]!.data.toDouble(),
      badgePositionPercentageOffset: searchChartStatsData[valueType]!.titlePosition,
      radius: standardPieChartRadius + (searchChartStatsData[valueType]!.data * 0.0002),
      badgeWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShadowText(
            searchChartStatsData[valueType]!.title,
            fontSize: responsiveUI.own(0.04),
            color: Colors.white,
          ),
          ShadowText(
            searchChartStatsData[valueType]!.data.toString(),
            fontWeight: FontWeight.bold,
            fontSize: responsiveUI.own(0.042),
            color: App.themeColor.secondary,
            shadows: [
              Shadow(
                color: Color.alphaBlend(
                  Colors.black,
                  App.themeColor.primary,
                ).withOpacity(0.5),
                blurRadius: 4,
              )
            ],
            forceShadow: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Stack(
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              width: responsiveUI.own(0.25),
              height: responsiveUI.own(0.25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShadowText(
                    'VNDB',
                    align: TextAlign.center,
                    fontSize: responsiveUI.normalSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  ShadowText(
                    'Statistics',
                    align: TextAlign.center,
                    fontSize: responsiveUI.normalSize,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          ScaleTransition(
            scale: _animationController.drive(CurveTween(curve: Curves.ease)),
            child: FadeTransition(
              opacity: _animationController.drive(CurveTween(curve: Curves.easeInToLinear)),
              child: Consumer(
                builder: (context, ref, child) {
                  final chartDegree = ref.watch(searchChartSpinControllerProvider);
                  final chartSpin = ref.watch(searchChartSpinControllerProvider.notifier);

                  return GestureDetector(
                    onPanUpdate: chartSpin.handlePan,
                    child: Container(
                      alignment: Alignment.center,
                      child: Transform.scale(
                        scale: (MediaQuery.of(context).orientation == Orientation.landscape) ? 0.77 : 0.8,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: chartDegree,
                            sectionsSpace: responsiveUI.own(0.01),
                            centerSpaceRadius: responsiveUI.own(0.2),
                            sections: [
                              for (String statsCode in searchChartStatsData.keys) _pieData(statsCode),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
