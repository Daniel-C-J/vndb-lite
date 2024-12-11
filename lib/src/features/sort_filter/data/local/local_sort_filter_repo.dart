import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sort_.dart';

part 'local_sort_filter_repo.g.dart';

// TODO change the names of providers, not like fetchPreviewProvider, but could be just previewprovider,

class LocalSortFilterRepo {
  LocalSortFilterRepo(this._sharedPref);

  final SharedPreferences _sharedPref;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void resetFilter() {
    _sharedPref.remove(DBKeys.COLLECTION_FILTER_CONF);
    _sharedPref.reload();
  }

  FilterData get latestFilterConf {
    final latestFilter = _sharedPref.getString(DBKeys.COLLECTION_FILTER_CONF);
    if (latestFilter != null) return FilterData.fromMap(json.decode(latestFilter));

    return Default.LOCAL_FILTER_CONF;
  }

  set latestFilterConf(FilterData filter) {
    final encodedFilterData = json.encode(filter.toMap());

    _sharedPref.setString(DBKeys.COLLECTION_FILTER_CONF, encodedFilterData);
    _sharedPref.reload();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void resetSort() {
    _sharedPref.remove(DBKeys.COLLECTION_SORT_CONF);
    _sharedPref.reload();
  }

  SortData get latestSortConf {
    final latestSort = _sharedPref.getString(DBKeys.COLLECTION_SORT_CONF);
    if (latestSort != null) return SortData.fromMap(json.decode(latestSort));

    return Default.LOCAL_SORT_CONF;
  }

  set latestSortConf(SortData sort) {
    final encodedSortData = json.encode(sort.toMap());

    _sharedPref.setString(DBKeys.COLLECTION_SORT_CONF, encodedSortData);
    _sharedPref.reload();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}

@Riverpod(dependencies: [sharedPref])
LocalSortFilterRepo localSortFilterRepo(Ref ref) {
  final sharedPref = ref.watch(sharedPrefProvider);
  return LocalSortFilterRepo(sharedPref);
}
