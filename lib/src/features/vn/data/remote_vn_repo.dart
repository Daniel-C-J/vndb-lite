import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/network_constant.dart';
import 'package:vndb_lite/src/core/network/api_service.dart';
import 'package:vndb_lite/src/features/search/domain/generic_vn_post.dart';

part 'remote_vn_repo.g.dart';

class RemoteVnRepo {
  RemoteVnRepo(this._apiService);

  final ApiService _apiService;

  static const vnEndpoint = "/kana/vn";
  static const releaseEndpoint = "/kana/release";

  Future<Response> fetchP1Data(String vnId, {CancelToken? cancelToken}) async {
    return await _apiService.post(
      endPoint: vnEndpoint,
      data: GenericPost(
        filters: ["id", "=", vnId],
        fields: APIConstants.P1_FIELDS,
      ).toMap(),
      cancelToken: cancelToken,
    );
  }

  Future<Response> fetchP2aData(String vnId, {CancelToken? cancelToken}) async {
    return await _apiService.post(
      endPoint: vnEndpoint,
      data: GenericPost(
        filters: ["id", "=", vnId],
        fields: APIConstants.P2a_FIELDS,
      ).toMap(),
      cancelToken: cancelToken,
    );
  }

  Future<Response> fetchP2bData(String vnId, {CancelToken? cancelToken}) async {
    return await _apiService.post(
      endPoint: releaseEndpoint,
      data: GenericPost(
        filters: [
          "vn",
          "=",
          ["id", "=", vnId]
        ],
        fields: APIConstants.P2b_FIELDS,
      ).toMap(),
      cancelToken: cancelToken,
    );
  }

  Future<Response> fetchP3Data(String vnId, {CancelToken? cancelToken}) async {
    return await _apiService.post(
      endPoint: vnEndpoint,
      data: GenericPost(
        filters: ["id", "=", vnId],
        fields: APIConstants.P3_FIELDS,
      ).toMap(),
      cancelToken: cancelToken,
    );
  }
}

@Riverpod(dependencies: [apiService])
RemoteVnRepo remoteVnRepo(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteVnRepo(apiService);
}
