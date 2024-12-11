import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/core/network/api_service.dart';
import 'package:vndb_lite/src/features/search/domain/generic_vn_post.dart';

part 'remote_sort_filter_repo.g.dart';

class RemoteSortFilterRepo {
  RemoteSortFilterRepo(this._apiService);

  final ApiService _apiService;

  Future<Response> fetchDevelopers(String devName, {CancelToken? cancelToken}) async {
    return await _apiService.post(
      endPoint: '/kana/producer',
      data: GenericPost(
        filters: ["search", "=", devName],
        fields: "name",
      ).toMap(),
      cancelToken: cancelToken,
    );
  }

  Future<Response> fetchTags(String tagName, {CancelToken? cancelToken}) async {
    return await _apiService.post(
      endPoint: '/kana/tag',
      data: GenericPost(
        filters: ["search", "=", tagName],
        fields: "name",
      ).toMap(),
      cancelToken: cancelToken,
    );
  }
}

@Riverpod(dependencies: [apiService])
RemoteSortFilterRepo remoteSortFilterRepo(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteSortFilterRepo(apiService);
}

@Riverpod(dependencies: [remoteSortFilterRepo])
Future<Response> fetchDevelopers(Ref ref, String devName, {CancelToken? cancelToken}) async {
  final remoteSortFilterRepo = ref.watch(remoteSortFilterRepoProvider);
  return await remoteSortFilterRepo.fetchDevelopers(devName, cancelToken: cancelToken);
}

@Riverpod(dependencies: [remoteSortFilterRepo])
Future<Response> fetchTags(Ref ref, String tagName, {CancelToken? cancelToken}) async {
  final remoteSortFilterRepo = ref.watch(remoteSortFilterRepoProvider);
  return await remoteSortFilterRepo.fetchTags(tagName, cancelToken: cancelToken);
}
