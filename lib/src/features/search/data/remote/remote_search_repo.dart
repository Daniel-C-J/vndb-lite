import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/constants/network_constant.dart';
import 'package:vndb_lite/src/core/network/api_service.dart';
import 'package:vndb_lite/src/features/search/data/search_repo_abstract.dart';
import 'package:vndb_lite/src/features/search/domain/generic_vn_post.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sort_.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

part 'remote_search_repo.g.dart';

class RemoteSearchRepoImpl implements RemoteSearchRepo {
  RemoteSearchRepoImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<Response> remoteSearchVn(GenericPost requestData, {CancelToken? cancelToken}) async {
    return await _apiService.post(
      endPoint: '/kana/vn',
      data: requestData.toMap(),
      cancelToken: cancelToken,
    );
  }

  GenericPost formatRemoteSearchRequest({
    required int pageResult,
    required SortData sortData,
    required FilterData filterData,
  }) {
    return GenericPost(
      fields: APIConstants.P1_FIELDS,
      filters: filterData.toList(),
      sort: sortData.sort,
      reverse: sortData.reverse,
      page: pageResult,
      results: Default.MAX_VN_SEARCH_RESULT,
    );
  }

  /// Formatting rawData into a classified model.
  List<VnDataPhase01> p1FromResponse(List result) {
    return [for (Map<String, dynamic> data in result) VnDataPhase01.fromMap(data)];
  }
}

@Riverpod(dependencies: [apiService])
RemoteSearchRepoImpl remoteSearchRepo(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteSearchRepoImpl(apiService);
}

@Riverpod(dependencies: [remoteSearchRepo])
Future<Response> remoteSearchVn(Ref ref, GenericPost requestData, {CancelToken? cancelToken}) async {
  final remoteSearchRepo = ref.watch(remoteSearchRepoProvider);
  return await remoteSearchRepo.remoteSearchVn(requestData, cancelToken: cancelToken);
}
