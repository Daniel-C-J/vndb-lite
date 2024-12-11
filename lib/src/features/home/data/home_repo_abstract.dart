import 'package:dio/dio.dart';
import 'package:vndb_lite/src/features/home/domain/home_sections_model.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

class RemoteHomeRepo {
  Future fetchPreview(HomePreviewSection sectionData, {CancelToken? cancelToken}) async {}

  Future cachePreview(List<VnDataPhase01> vnData, {required String cacheKey}) async {}
}

class LocalHomeRepo {
  bool doesCacheExist(String cacheKey) => true;

  Future fetchCachedPreview(int maxPreviewItem, {required String cacheKey}) => Future.value(0);
}
