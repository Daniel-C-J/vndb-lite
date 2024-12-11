import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:vndb_lite/src/util/custom_cache_manager.dart';

Future<bool> didMediaCache(String key) async {
  if (await CustomCacheManager().getFileFromCache(key) != null) return true;
  if (await CustomCacheManager().getFileFromMemory(key) != null) return true;
  if (await DefaultCacheManager().getFileFromCache(key) != null) return true;
  if (await DefaultCacheManager().getFileFromMemory(key) != null) return true;

  return false;
}
