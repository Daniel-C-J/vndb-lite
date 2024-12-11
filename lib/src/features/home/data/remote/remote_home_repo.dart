import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vndb_lite/src/constants/network_constant.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/core/network/api_service.dart';
import 'package:vndb_lite/src/features/home/domain/home_sections_model.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/home/data/home_repo_abstract.dart';
import 'package:vndb_lite/src/features/search/domain/generic_vn_post.dart';

part 'remote_home_repo.g.dart';

// TODO simple documentation of classes
// TODO repo should not depend onto another

class RemoteHomeRepoImpl implements RemoteHomeRepo {
  RemoteHomeRepoImpl(
    this._apiService,
    this._sharedPref,
    this._localVnRepo,
  );

  final ApiService _apiService;
  final SharedPreferences _sharedPref;
  final LocalVnRepo _localVnRepo;

  /// Fetch data from VNDB api using [ApiService].
  /// Will be used in [HomeService] for the success data processed into a model.
  @override
  Future<Response> fetchPreview(HomePreviewSection sectionData, {CancelToken? cancelToken}) async {
    final postData = _convertSectionDataToPostData(sectionData);

    return await _apiService.post(
      endPoint: '/kana/vn',
      data: postData.toMap(),
      cancelToken: cancelToken,
    );
  }

  GenericPost _convertSectionDataToPostData(HomePreviewSection sectionData) {
    return GenericPost(
      reverse: true,
      sort: sectionData.labelCode,
      fields: APIConstants.P1_FIELDS,
      filters: sectionData.filter?.toList(),
      results: sectionData.maxPreviewItem,
    );
  }

  /// This method allows for the fetched preview data to be processed centrally inside [LocalHomeRepo].
  @override
  Future<void> cachePreview(List<VnDataPhase01> vnData, {required String cacheKey}) async {
    final List<String> vnIds = [];

    for (VnDataPhase01 vnDataP1 in vnData) {
      await _localVnRepo.saveVnContent(vnDataP1);
      vnIds.add(vnDataP1.id);
    }

    _sharedPref.setStringList(cacheKey, vnIds);
    _sharedPref.reload();
  }
}

@Riverpod(dependencies: [apiService, sharedPref, localVnRepo])
RemoteHomeRepoImpl remoteHomeRepo(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  final sharedPref = ref.watch(sharedPrefProvider);
  final localVnRepo = ref.watch(localVnRepoProvider);
  return RemoteHomeRepoImpl(apiService, sharedPref, localVnRepo);
}

@Riverpod(dependencies: [remoteHomeRepo])
Future<Response> fetchPreview(Ref ref, HomePreviewSection sectionData, {CancelToken? cancelToken}) async {
  final remoteHomeRepo = ref.watch(remoteHomeRepoProvider);
  return await remoteHomeRepo.fetchPreview(sectionData, cancelToken: cancelToken);
}

@Riverpod(dependencies: [remoteHomeRepo])
Future<void> cachePreview(Ref ref, List<VnDataPhase01> vnData, {required String cacheKey}) {
  final remoteHomeRepo = ref.watch(remoteHomeRepoProvider);
  return remoteHomeRepo.cachePreview(vnData, cacheKey: cacheKey);
}
