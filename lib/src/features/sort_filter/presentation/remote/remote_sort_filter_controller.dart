import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/developers.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sort_.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';

part 'remote_sort_filter_controller.g.dart';

@Riverpod(keepAlive: true)
class AppliedRemoteFilterController extends _$AppliedRemoteFilterController {
  @override
  FilterData build() {
    return Default.REMOTE_FILTER_CONF;
  }

  void importFilterData(FilterData filter) {
    state = filter;
  }

  void copyWith({
    String? search,
    String? andOr,
    List<String>? lang,
    List<int>? devstatus,
    List<String>? olang,
    List<String>? platform,
    List<VnTag>? tag,
    List<Developer>? dev,
    int? minage,
  }) {
    state = FilterData(
      search: search ?? state.search,
      andOr: andOr ?? state.andOr,
      lang: lang ?? state.lang,
      devstatus: devstatus ?? state.devstatus,
      olang: olang ?? state.olang,
      platform: platform ?? state.platform,
      tag: tag ?? state.tag,
      dev: dev ?? state.dev,
      minage: minage ?? state.minage,
    );
  }

}

@Riverpod(keepAlive: true)
class AppliedRemoteSortController extends _$AppliedRemoteSortController {
  @override
  SortData build() {
    return Default.REMOTE_SORT_CONF;
  }

  void copyWith({
    bool? reverse,
    String? sort,
  }) {
    state = SortData(
      reverse: reverse ?? state.reverse,
      sort: sort ?? state.sort,
    );
  }

  void importSortData(SortData sort) {
    state = sort;
  }

}

@Riverpod(keepAlive: true)
class TempRemoteFilterController extends _$TempRemoteFilterController {
  @override
  FilterData build() {
    return Default.REMOTE_FILTER_CONF;
  }

  void importFilterData(FilterData filter) {
    state = filter;
  }

  void copyWith({
    String? search,
    String? andOr,
    List<String>? lang,
    List<int>? devstatus,
    List<String>? olang,
    List<String>? platform,
    List<VnTag>? tag,
    List<Developer>? dev,
    int? minage,
  }) {
    state = FilterData(
      search: search ?? state.search,
      andOr: andOr ?? state.andOr,
      lang: lang ?? state.lang,
      devstatus: devstatus ?? state.devstatus,
      olang: olang ?? state.olang,
      platform: platform ?? state.platform,
      tag: tag ?? state.tag,
      dev: dev ?? state.dev,
      minage: minage ?? state.minage,
    );
  }

}

@Riverpod(keepAlive: true)
class TempRemoteSortController extends _$TempRemoteSortController {
  @override
  SortData build() {
    return Default.REMOTE_SORT_CONF;
  }

  void copyWith({
    bool? reverse,
    String? sort,
  }) {
    state = SortData(
      reverse: reverse ?? state.reverse,
      sort: sort ?? state.sort,
    );
  }

  void importSortData(SortData sort) {
    state = sort;
  }

}
