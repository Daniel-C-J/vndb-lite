import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/filter_vn_collection.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/sort_vn_collection.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/components/tab_header.dart';

class BottomSheetCollection extends ConsumerStatefulWidget {
  const BottomSheetCollection({super.key});

  @override
  ConsumerState<BottomSheetCollection> createState() {
    return _BottomSheetCollectionState();
  }
}

class _BottomSheetCollectionState extends ConsumerState<BottomSheetCollection> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.7,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomRight,
            begin: Alignment.topLeft,
            colors: [
              App.themeColor.primary.withOpacity(0.8),
              App.themeColor.primary.withOpacity(0.8),
              (App.themeColor.tertiary == Colors.black)
                  ? const Color.fromARGB(180, 240, 230, 230)
                  : const Color.fromARGB(180, 40, 40, 40),
            ],
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tab header
                  FilterTabHeader(tabController: _tabController),
                  ContentSizeTabBarView(
                    controller: _tabController,
                    children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Sort
                      Padding(
                        padding: EdgeInsets.only(bottom: responsiveUI.own(0.06)),
                        child: const SortVnCollection(),
                      ),

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Filter
                      Padding(
                        padding: EdgeInsets.only(
                          top: responsiveUI.own(0.05),
                          bottom: responsiveUI.own(0.06),
                        ),
                        child: const FilterVnCollection(),
                      ),
                    ],
                  )
                ],
              ),
            ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
          ],
        ),
      ),
    );
  }
}
