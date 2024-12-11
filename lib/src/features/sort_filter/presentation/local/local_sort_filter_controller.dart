import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/sort_filter/data/local/local_sort_filter_repo.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/developers.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sort_.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';

part 'local_sort_filter_controller.g.dart';

@riverpod
class LocalFilterController extends _$LocalFilterController {
  @override
  FilterData build() {
    return ref.watch(localSortFilterRepoProvider).latestFilterConf;
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
    final tempState = FilterData(
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

    ref.read(localSortFilterRepoProvider).latestFilterConf = tempState;
    state = tempState;
  }

  void reset() {
    ref.read(localSortFilterRepoProvider).resetFilter();
    state = ref.read(localSortFilterRepoProvider).latestFilterConf.copyWith(search: state.search);
  }

  void importFilterData(FilterData filter) {
    state = filter;
    ref.read(localSortFilterRepoProvider).latestFilterConf = state;
  }

  set minage(int age) {
    state = state.copyWith(minage: age);
    ref.read(localSortFilterRepoProvider).latestFilterConf = state;
  }

  set lang(List<String> lang) {
    state = state.copyWith(lang: lang);
    ref.read(localSortFilterRepoProvider).latestFilterConf = state;
  }

  set devstatus(List<int> devstatus) {
    state = state.copyWith(devstatus: devstatus);
    ref.read(localSortFilterRepoProvider).latestFilterConf = state;
  }

  set olang(List<String> olang) {
    state = state.copyWith(olang: olang);
    ref.read(localSortFilterRepoProvider).latestFilterConf = state;
  }

  set platform(List<String> platform) {
    state = state.copyWith(platform: platform);
    ref.read(localSortFilterRepoProvider).latestFilterConf = state;
  }
}

@riverpod
class LocalSortController extends _$LocalSortController {
  @override
  SortData build() {
    return ref.watch(localSortFilterRepoProvider).latestSortConf;
  }

  void copyWith({
    bool? reverse,
    String? sort,
  }) {
    final tempState = SortData(
      reverse: reverse ?? state.reverse,
      sort: sort ?? state.sort,
    );

    ref.read(localSortFilterRepoProvider).latestSortConf = tempState;
    state = tempState;
  }

  void reset() {
    ref.read(localSortFilterRepoProvider).resetSort();
    state = ref.read(localSortFilterRepoProvider).latestSortConf;
  }

  set reverse(bool reverse) {
    state = state.copyWith(reverse: reverse);
    ref.read(localSortFilterRepoProvider).latestSortConf = state;
  }

  set sort(String sort) {
    state = state.copyWith(sort: sort);
    ref.read(localSortFilterRepoProvider).latestSortConf = state;
  }
}
