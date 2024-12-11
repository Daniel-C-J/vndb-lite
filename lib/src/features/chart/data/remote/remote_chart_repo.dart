import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/core/network/api_service.dart';

part 'remote_chart_repo.g.dart';

class RemoteChartRepo {
  RemoteChartRepo(this._apiService);

  final ApiService _apiService;

  static const statsEndpoint = "/kana/stats";

  Future<Response> fetchStats({CancelToken? cancelToken}) async {
    return await _apiService.get(endPoint: statsEndpoint);
  }
}

@Riverpod(dependencies: [apiService])
RemoteChartRepo remoteChartRepo(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RemoteChartRepo(apiService);
}
