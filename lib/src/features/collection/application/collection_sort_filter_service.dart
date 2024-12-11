import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/features/collection/application/local_filter_service.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection/presentation/collection_content_controller.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sort_.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/vn_item_grid_.dart';
import 'package:vndb_lite/src/util/unique_valuekey.dart';

part 'collection_sort_filter_service.g.dart';

/// A service class to do some heavy processing such as sorting and filtering vn data.
class CollectionSortFilterService {
  CollectionSortFilterService(this.ref);

  final Ref ref;

  /// This method sorts all of the adapted vn data based on the given sort configuration.
  Future<void> sortData(SortData conf) async {
    final String sortBy = conf.sort;

    if (conf.reverse!) {
      for (String statusName in COLLECTION_STATUS_DATA.keys) {
        rawP1BasedOnStatus[statusName]!.sort((a, b) => b[sortBy].compareTo(a[sortBy]));
      }
      return;
    }

    for (String statusName in COLLECTION_STATUS_DATA.keys) {
      rawP1BasedOnStatus[statusName]!.sort((a, b) => a[sortBy].compareTo(b[sortBy]));
    }
  }

  /// This method filters all of the adapted vn data based on the given filter configuration.
  Future<void> filterData(FilterData filter, SortData sort) async {
    final filterService = ref.read(localFilterServiceProvider);
    final List<String> searchKeywords = _getSearchKeywords(filter.search);

    for (String statusName in COLLECTION_STATUS_DATA.keys) {
      //
      for (Map<String, dynamic> adaptedVnData in rawP1BasedOnStatus[statusName]!) {
        // If not using any filter, then simply ignore all the filter check.
        if (!isUsingFilter(filter)) {
          _addToVnWidgetList(adaptedVnData, statusName: statusName, sort: sort);
          continue;
        }

        final Map<String, dynamic> searchFilter = {
          "keywords": searchKeywords,
          "searchQuery": filter.search,
          "dataToBeSearched": _getDataForSearchQuery(filter.search, adaptedVnData),
        };

        final bool canContinue = await _canVnPassFilters(filter, filterService, searchFilter, adaptedVnData);
        if (canContinue) await _addToVnWidgetList(adaptedVnData, statusName: statusName, sort: sort);
      }
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool isUsingFilter(FilterData conf) {
    // Checks whether the current filter is not the same as the default one or
    // the same.
    return conf.copyWith(search: conf.search.trim()) != Default.LOCAL_FILTER_CONF;
  }

  List<String> _getSearchKeywords(String? searchQuery) {
    if (searchQuery!.length > 4 && searchQuery.substring(0, 4) == 'dev:') {
      return searchQuery.substring(4, searchQuery.length).split(',');
    }

    if (searchQuery.length > 4 && searchQuery.substring(0, 4) == 'tag:') {
      return searchQuery.substring(4, searchQuery.length).split(',');
    }

    return [];
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool _isSearchingForAll(String? searchQuery) {
    return searchQuery == " " || searchQuery == null || searchQuery.isEmpty;
  }

  bool _isSearchingForDevs(String searchQuery) {
    return searchQuery.length > 4 && searchQuery.substring(0, 4) == 'dev:';
  }

  bool _isSearchingForTags(String searchQuery) {
    return searchQuery.length > 4 && searchQuery.substring(0, 4) == 'tag:';
  }

  String _getDataForSearchQuery(String? searchQuery, Map<String, dynamic> vnData) {
    if (_isSearchingForAll(searchQuery)) return " ";
    if (_isSearchingForDevs(searchQuery!)) return "${vnData['devs']}";
    if (_isSearchingForTags(searchQuery)) return "${vnData['tags']}";

    return "${vnData['title']} ${vnData['aliases']}";
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
  Future<bool> _canVnPassFilters(
    FilterData filter,
    LocalFilterService service,
    Map<String, dynamic> searchFilter,
    Map<String, dynamic> adaptedVnData,
  ) async {
    //
    // Filter starts from the search query.
    if (service.searchFiltered(searchFilter)) {
      //
      // Minimum age.
      if (service.minageFiltered(filter.minage, adaptedVnData)) {
        //
        //  Development status.
        if (service.devStatFiltered(filter.devstatus, adaptedVnData)) {
          //
          // Original Language.
          if (service.originlangFiltered(filter.olang, adaptedVnData)) {
            //
            // Available platforms.
            if (service.platformFiltered(filter.platform, adaptedVnData)) {
              //
              // Finally the available languages.
              if (service.languagesFiltered(filter.lang, adaptedVnData)) {
                //
                //
                return true;
              }
            }
          }
        }
      }
    }

    return false;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _addToVnWidgetList(
    Map<String, dynamic> adaptedVnData, {
    required String statusName,
    required SortData sort,
  }) async {
    ref.read(collectionContentControllerProvider.notifier).add(statusCode: statusName, data: [
      VnItemGrid(
        key: uidKeyOf(adaptedVnData['id']),
        p1: VnDataPhase01.fromMap(adaptedVnData),
        labelCode: sort.sort,
        isGridView: true,
      ),
    ]);

    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}

@riverpod
CollectionSortFilterService collectionSortFilterService(Ref ref) {
  return CollectionSortFilterService(ref);
}
