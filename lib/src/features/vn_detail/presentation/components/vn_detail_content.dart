import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection_selection/presentation/fab/vn_detail_fab_state.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/general/vn_detail_general.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/header/vn_detail_bottom_header.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/header/vn_detail_top_header.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/relations/vn_detail_relations_entrance.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/release/vn_detail_releases.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';

class VnDetailsContent extends ConsumerStatefulWidget {
  const VnDetailsContent({
    super.key,
    required this.p1,
    required this.p2,
  });

  final VnDataPhase01 p1;
  final VnDataPhase02 p2;

  @override
  ConsumerState<VnDetailsContent> createState() {
    return _VnDetailsContentState();
  }
}

class _VnDetailsContentState extends ConsumerState<VnDetailsContent> with TickerProviderStateMixin {
  late final TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)
      ..forward();

    // Shows floating action button once this class rendered.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(vnDetailFabStateProvider(widget.p1.id).notifier).show = true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: responsiveUI.own(0.1)),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Headers
        VnDetailsTopHeader(
          p1: widget.p1,
          p2: widget.p2,
          animationController: _animationController,
        ),
        SizedBox(height: responsiveUI.own(0.05)),
        VnDetailsBottomHeader(
          p1: widget.p1,
          p2: widget.p2,
        ),
        SizedBox(height: responsiveUI.own(0.025)),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tabs
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: responsiveUI.own(0.045)),
          child: Container(
            width: MediaQuery.sizeOf(context).width - measureSafeAreaOf(responsiveUI.own(0.045)),
            height: responsiveUI.own(0.075),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  App.themeColor.secondary.withOpacity(0.6),
                  App.themeColor.secondary.withOpacity(0.3),
                ],
              ),
            ),
            child: Stack(
              children: [
                TabBar(
                  dividerHeight: 0,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: App.themeColor.primary,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(180, 0, 0, 0),
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      )
                    ],
                  ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tab headers
                  tabs: [
                    Tab(
                      child: ShadowText(
                        'General',
                        color: App.themeColor.tertiary,
                      ),
                    ),
                    Tab(
                      child: ShadowText(
                        'Release',
                        color: App.themeColor.tertiary,
                      ),
                    ),
                    Tab(
                      child: ShadowText(
                        'Relations',
                        color: App.themeColor.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: responsiveUI.own(0.025)),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tab content
        ContentSizeTabBarView(
          controller: _tabController,
          children: [
            VnDetailsContentGeneral(
              p1: widget.p1,
              p2: widget.p2,
            ),
            VnDetailsContentReleases(
              p1: widget.p1,
              p2: widget.p2,
            ),
            VnDetailsContentRelationsEntrance(
              vnId: widget.p1.id,
            ),
          ],
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
