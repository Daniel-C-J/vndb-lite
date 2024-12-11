import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/generic_failure_connection.dart';
import 'package:vndb_lite/src/common_widgets/generic_local_empty_content.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/home/application/home_preview_service.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/home/domain/home_sections_model.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/vn_item_grid_.dart';

/// A simple horizontal-slide widget consisting a list of vn items.
class HomeSectionContent extends ConsumerWidget {
  const HomeSectionContent({
    super.key,
    required this.sectionData,
  });

  final HomePreviewSection sectionData;

  // Height will be smaller when landscape.
  double get _sectionContentHeight {
    final context = NavigationService.currentContext;

    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? responsiveUI.own(0.55)
        : responsiveUI.own(0.45);
  }

  bool get _isCollection {
    return sectionData.labelCode == SortableCode.collection.name;
  }

  String get _previewCacheKey {
    // TODO watchout with this key, if in the future, there will be another
    // preview involving collection
    if (_isCollection) return DBKeys.COLLECTION_PREVIEW_CACHE_KEY;

    final String newTitle = sectionData.title.toUpperCase().replaceAll(' ', '-');
    return "${DBKeys.HOME_PREVIEW_CACHE_KEY}$newTitle";
  }

  Widget get _loading {
    return const Center(child: CircularProgressIndicator());
  }

  Widget get _error {
    // Exclusive for collection/local content.
    if (_isCollection) {
      return GenericLocalEmptyWidget();
    }

    return SizedBox(
      width: MediaQuery.sizeOf(NavigationService.currentContext).width * 0.9,
      child: GenericFailureConnection(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewData = ref.watch(getPreviewDataProvider(
      cacheKey: _previewCacheKey,
      sectionData: sectionData,
    ));

    return previewData.when(
      data: (rawData) {
        // Formatting rawData into a classified model.
        final formattedPreviewDt = ref.watch(formatPreviewDataProvider(
          rawData,
          cacheKey: _previewCacheKey,
        ));

        return formattedPreviewDt.when(
          data: (List<VnDataPhase01> data) {
            final formattedP1Data = data;

            if (formattedP1Data.isEmpty) {
              return GenericLocalEmptyWidget();
            }

            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: _sectionContentHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (VnDataPhase01 p1 in formattedP1Data)
                      VnItemGrid(
                        key: UniqueKey(),
                        p1: p1,
                        isGridView: false,
                        labelCode: sectionData.labelCode!,
                      ),
                  ],
                ),
              ),
            );
          },
          error: (error, st) {
            // Logging error.
            debugPrint('Formatting data error.');
            debugPrint('${error.toString()}\n${st.toString()}');
            return _error;
          },
          loading: () {
            return _loading;
          },
        );
      },
      error: (error, st) {
        // Logging error.
        debugPrint('Fetching data error.');
        debugPrint('${error.toString()}\n${st.toString()}');
        return _error;
      },
      loading: () {
        return _loading;
      },
    );
  }
}
