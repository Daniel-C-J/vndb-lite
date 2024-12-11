import 'package:flutter/scheduler.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/_base/presentation/maintab_layout.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:vndb_lite/src/features/settings/presentation/settings_general_state.dart';
import 'package:vndb_lite/src/util/balanced_safearea.dart';
import 'package:vndb_lite/src/util/unique_valuekey.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({
    super.key,
  });

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  @override
  void initState() {
    super.initState();

    // If there is not any ongoing process, then proceeds.
    if (!ref.read(bottomProgressIndicatorProvider)) {
      ref.read(collectionContentControllerProvider.notifier).separateVNsByStatus();
    }
  }

  void _forceUpdateUI() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(collectionContentNotifierProvider.notifier).end();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsGeneralStateProvider);
    final statusArrangement = settings.collectionStatusTabArrangement;

    return Padding(
      padding: EdgeInsets.only(
        top: responsiveUI.own(0.04),
        right: measureSafeAreaOf(0),
      ),
      child: ContentSizeTabBarView(
        controller: collectionTabController,
        children: [
          for (String statusName in statusArrangement)
            Consumer(
              builder: (context, ref, child) {
                final vnItemGrids = ref.watch(collectionContentControllerProvider);
                final notifyCollection = ref.watch(collectionContentNotifierProvider);

                if (notifyCollection) {
                  _forceUpdateUI();
                }

                return CollectionContent(
                  key: uidKeyOf(statusName),
                  content: vnItemGrids[statusName] ?? [],
                );
              },
            )
        ],
      ),
    );
  }
}
