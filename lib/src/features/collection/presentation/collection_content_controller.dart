import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/core/network/network_helper.dart';
import 'package:vndb_lite/src/features/_base/presentation/lower_parts/bottom_progress_indicator_state.dart';
import 'package:vndb_lite/src/features/collection/application/collection_vn_service.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection/data/local/local_collection_repo.dart';
import 'package:vndb_lite/src/features/collection/domain/adapted_vn.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';
import 'package:vndb_lite/src/features/collection/application/collection_sort_filter_service.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/filter_.dart';
import 'package:vndb_lite/src/features/sort_filter/presentation/local/local_sort_filter_controller.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/others.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/vn_item_grid_.dart';

part 'collection_content_controller.g.dart';

// Containing raw vn data.
final Map<String, List<Map<String, dynamic>>> rawP1BasedOnStatus = {};

/// This notifier is to forcefully update the UI.
@riverpod
class CollectionContentNotifier extends _$CollectionContentNotifier {
  @override
  bool build() {
    return true;
  }

  void ring() => state = true;
  void end() => state = false;
}

@riverpod
class CollectionContentController extends _$CollectionContentController {
  @override
  Map<String, List<VnItemGrid>> build() {
    return {};
  }

  void add({required String statusCode, required List<VnItemGrid> data}) {
    if (state.containsKey(statusCode)) {
      final tempData = state[statusCode];
      tempData!.addAll(data);

      state[statusCode] = tempData;
    } else {
      state[statusCode] = data;
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> separateVNsByStatus([bool searchOnly = false]) async {
    final alreadyThereAProcess = ref.read(bottomProgressIndicatorProvider);

    // For the sake of simplicity, the progress indicator will be treated in here
    if (!alreadyThereAProcess) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ref.read(bottomProgressIndicatorProvider.notifier).show = true;
      });
    }

    final sharedPref = ref.read(sharedPrefProvider);
    final collectionHandler = ref.read(collectionSortFilterServiceProvider);
    final localCollectionRepo = ref.read(localCollectionRepoProvider);
    final localFilter = ref.read(localFilterControllerProvider);
    final localSort = ref.read(localSortControllerProvider);

    try {
      sharedPref.reload();
      final List<String> dbCollection = localCollectionRepo.rawAllRecords;
      cleanCurrentData(searchOnly);

      if (dbCollection.isEmpty) return;

      if (!searchOnly) {
        await _adaptingRawData(localFilter);
        await collectionHandler.sortData(localSort);
      }

      await collectionHandler.filterData(localFilter, localSort);
      ref.read(collectionContentNotifierProvider.notifier).ring();
      //
    } catch (e) {
      //
    } finally {
      // Expecting that the caller of this function has another process and will handle the progress indicator
      // further, so it doesn't have to be turned off.
      if (!alreadyThereAProcess) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ref.read(bottomProgressIndicatorProvider.notifier).show = false;
        });
      }
    }

    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void cleanCurrentData(bool searchOnly) {
    for (String statusName in COLLECTION_STATUS_DATA.keys) {
      // This means that when searching only, rawdata is safe and can be processed
      // into widget with the new given filter or sort configuration, without having to
      // generate all the raw vnData again.
      if (!searchOnly) {
        rawP1BasedOnStatus[statusName] = [];
      }

      state[statusName] = []; // Widgets clean
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _adaptingRawData(FilterData conf) async {
    final localCollectionRepo = ref.read(localCollectionRepoProvider);
    final networkInfo = ref.read(networkInfoProvider);
    final localVnRepo = ref.read(localVnRepoProvider);

    for (VnRecord vnRecord in await localCollectionRepo.getAllRecords()) {
      final String vnId = vnRecord.id;
      final String statusName = vnRecord.status.toLowerCase();

      // Prevent duplication, will remove duplication and skip the current vn.
      if (_hasDuplicate(statusName, vnId)) {
        _removeDuplication(statusName, vnId);
        continue;
      }

      // Checks whether either p1 or p2 data is null for the corresponding vn.
      if (!localVnRepo.p1Exist(vnId) || !localVnRepo.p2Exist(vnId)) {
        bool isConnected = false;

        await Future.delayed(const Duration(milliseconds: 1500));
        final valid = await ref.read(validateVnAndSaveToLocalProvider(vnId).future);
        isConnected = await networkInfo.isConnected;

        // Skip the loop. Ignore the current record.
        if (!valid) {
          // Will delete current vn record, if even with internet connection access, the corresponding
          // vn is not valid.
          if (isConnected) localCollectionRepo.removeVnRecord(vnId);
          continue;
        }
      }

      // Clustering each vn item collection record by its status.
      final AdaptedVnData vnData = await getAdaptedVnData(vnRecord);
      rawP1BasedOnStatus[statusName]!.add(vnData.toMap());
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool _hasDuplicate(String statusName, String vnId) {
    return (state[statusName] ?? []).where((item) => item.p1.id == vnId).isNotEmpty;
  }

  void _removeDuplication(String statusName, String vnId) {
    rawP1BasedOnStatus[statusName]!.removeWhere((record) => record['id'] == vnId);
    state[statusName]!.removeWhere((record) => record.p1.id == vnId);
  }

  Future<AdaptedVnData> getAdaptedVnData(VnRecord vnRecord) async {
    final localVnRepo = ref.read(localVnRepoProvider);

    final VnDataPhase01 p1 = (await localVnRepo.getP1(vnRecord.id))!;
    final VnDataPhase02 p2 = (await localVnRepo.getP2(vnRecord.id))!;

    final AdaptedVnData adaptedData = AdaptedVnData(
      id: vnRecord.id,
      status: vnRecord.status,
      title: vnRecord.title,
      started: vnRecord.started ?? '0',
      added: vnRecord.added ?? '0',
      vote: vnRecord.vote,
      // Using full p1, since at the end of the filtering process, it will be used by VnItemrid.
      p1: p1,
      aliases: p2.aliases!,
      length_minutes: p2.length_minutes!,
      devs: p2.developers!,
      devstatus: p2.devstatus!,
      languages: p2.languages!,
      minage: p2.minage!,
      tags: [for (VnTag tag in p2.tags!) tag.name!],
      platforms: p2.platforms!,
    );

    // Uncomment either one below for optimization.
    // Unknown minage will be treated as All-ages.
    // if (adaptedData.minage.isEmpty) final newData = adaptedData.copyWith(minage: [0, 1]);

    // Unknown minage will be treated as Adult-only.
    // if (adaptedData.minage.isEmpty) final newData = adaptedData.copyWith(minage: [19, 20]);

    return adaptedData;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}
