import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/home/domain/home_sections_model.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/home/data/local/local_home_repo.dart';
import 'package:vndb_lite/src/features/home/data/remote/remote_home_repo.dart';

part 'home_preview_service.g.dart';

class HomePreviewService {
  HomePreviewService(this.ref);

  final Ref ref;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  /// Fetch both remote raw json data and local string ids preview data.
  /// Returning either stream of strings or a response.
  FutureOr<dynamic> getPreviewData({
    required HomePreviewSection sectionData,
    required String cacheKey,
    CancelToken? cancelToken,
  }) async {
    final localRepo = ref.read(localHomeRepoProvider);
    final remoteRepo = ref.read(remoteHomeRepoProvider);

    if (localRepo.doesCacheExist(cacheKey) || sectionData.labelCode == SortableCode.collection.name) {
      return await localRepo.fetchCachedPreview(sectionData.maxPreviewItem, cacheKey: cacheKey);
      //
    } else {
      //
      return await remoteRepo.fetchPreview(sectionData);
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  /// Format both remote raw json data and local string ids preview data.
  Future<List<VnDataPhase01>> formatPreviewData(dynamic data, {required String cacheKey}) async {
    final localVnRepo = ref.read(localVnRepoProvider);
    final p1 = <VnDataPhase01>[];
    var rawData;

    // Formatting rawData. Mainly if data is from remote datasource.
    if (data is Response) {
      rawData = data.data['results'];
    } else if (data is List<String>) {
      rawData = data;
    }

    bool toBeCached = false;

    for (var dt in rawData) {
      // This expects whether rawdata is coming from remote or local datasource.
      if (dt is Map<String, dynamic>) {
        p1.add(VnDataPhase01.fromMap(dt));

        // Cache data if data came from remote datasource.
        toBeCached = true;
        //
      } else if (dt is String) {
        //
        p1.add((await localVnRepo.getP1(dt))!);
      }
    }

    if (toBeCached) {
      await cachePreviewData(p1, cacheKey: cacheKey);
    }

    return p1;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  /// Should only cache preview data from remote datasource, do not cache from local
  /// since it will override the exisiting value, especially the data phases, which is
  /// not necessary to save to local again (wasting the runtime).
  Future<void> cachePreviewData(List<VnDataPhase01> vnData, {required String cacheKey}) async {
    final remoteHomeRepo = ref.read(remoteHomeRepoProvider);
    await remoteHomeRepo.cachePreview(vnData, cacheKey: cacheKey);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void refreshRemotePreviews() {
    final localHomeRepo = ref.read(localHomeRepoProvider);
    localHomeRepo.clearAllCachedPreviews();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
//
}

@riverpod
HomePreviewService homePreviewService(Ref ref) {
  return HomePreviewService(ref);
}

@Riverpod(dependencies: [homePreviewService])
FutureOr<dynamic> getPreviewData(
  Ref ref, {
  required HomePreviewSection sectionData,
  required String cacheKey,
  CancelToken? cancelToken,
}) async {
  final homePreviewService = ref.watch(homePreviewServiceProvider);

  return await homePreviewService.getPreviewData(
    cacheKey: cacheKey,
    sectionData: sectionData,
    cancelToken: cancelToken,
  );
}

@Riverpod(dependencies: [homePreviewService])
Future<List<VnDataPhase01>> formatPreviewData(Ref ref, dynamic rawData, {required String cacheKey}) async {
  final homePreviewService = ref.watch(homePreviewServiceProvider);
  return homePreviewService.formatPreviewData(rawData, cacheKey: cacheKey);
}
