import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/collection/application/collection_vn_service.dart';
import 'package:vndb_lite/src/features/collection/data/local/local_collection_repo.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';
import 'package:vndb_lite/src/features/sync/data/local/local_sync_repo.dart';
import 'package:vndb_lite/src/util/custom_cache_manager.dart';

part 'settings_service.g.dart';

class SettingsService {
  SettingsService(this.ref);

  final Ref ref;

  Future<void> refresh({void Function(String)? onRefresh}) async {
    final localCollectionRepo = ref.read(localCollectionRepoProvider);
    final List<VnRecord> localRecords = await localCollectionRepo.getAllRecords();

    for (VnRecord record in localRecords) {
      // This will both download and save phase01 and phase02 vn data.
      await ref.read(validateVnAndSaveToLocalProvider(record.id).future);
      await localCollectionRepo.saveVnRecord(record);

      await Future.delayed(const Duration(milliseconds: 2500));
      if (onRefresh != null) onRefresh(record.title);
    }
  }

  Future<void> deleteAll({required bool sync}) async {
    ref.read(localCollectionRepoProvider).removeAllCollection(includeSync: sync);
  }

  Future<void> clearCache() async {
    final sharedPref = ref.read(sharedPrefProvider);

    // Clearing all SharedPreferences, temp data, and cache managers.
    sharedPref.clear();
    sharedPref.reload();
    await CustomCacheManager().emptyCache();
    await DefaultCacheManager().emptyCache();
    sharedPref.reload();
  }

  Future<void> removeAuth() async {
    ref.read(localCollectionRepoProvider).cleanVnToBeRemovedWhenSync();
    ref.read(localSyncRepoProvider).reset();
    return;
  }
}

@riverpod
SettingsService settingsService(Ref ref) {
  return SettingsService(ref);
}
