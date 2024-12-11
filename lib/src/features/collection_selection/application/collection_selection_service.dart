import 'dart:ui';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection/data/local/local_collection_repo.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';
import 'package:vndb_lite/src/features/collection_selection/application/collection_selection_remote_service.dart';
import 'package:vndb_lite/src/features/collection_selection/domain/vn_selection.dart';
import 'package:vndb_lite/src/features/sync/data/local/local_sync_repo.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

part 'collection_selection_service.g.dart';

class VnSelectionService {
  VnSelectionService(this.ref);

  final Ref ref;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Map<String, VnRecord?> getVnRecords(List<VnDataPhase01> p1) {
    final collection = ref.read(localCollectionRepoProvider);
    final Map<String, VnRecord?> vnRecords = {};

    for (VnDataPhase01 selectedVn in p1) {
      final VnRecord? vnInCollection = collection.getVnRecordFromId(selectedVn.id);
      vnRecords[selectedVn.id] = vnInCollection;
    }

    return vnRecords;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> confirmSelection({
    required List<VnDataPhase01> p1List,
    required Map<String, VnRecord?> vnRecords,
    required VnSelection selection,
    required VoidCallback whenSuccess,
    required Function(Object, StackTrace) whenErr,
    required void Function(String) saveRefresh,
  }) async {
    final localVnRepo = ref.read(localVnRepoProvider);

    try {
      // TODO watchout with this one [0], since it indirectly telling that downloading p2 data only supported by
      // single selection record, not multiselection.
      if (!localVnRepo.p2Exist(p1List[0].id)) await _downloadP2Data(p1List);
      await _saveCollection(
        selection: selection,
        vnRecords: vnRecords,
        p1List: p1List,
        saveRefresh: saveRefresh,
      );
      whenSuccess();
    } catch (err, st) {
      whenErr(err, st);
    }
  }

  Future<void> removeSelection(
    List<VnRecord?> vnRecords, {
    required VoidCallback whenSuccess,
    required void Function(String) removeRefresh,
  }) async {
    final localCollection = ref.read(localCollectionRepoProvider);
    final syncRepo = ref.read(localSyncRepoProvider);

    List<String> removeVnIds = localCollection.vnToBeRemovedWhenSync;

    for (var record in vnRecords) {
      if (record == null) continue;

      // Removing the current record.
      localCollection.removeVnRecord(record.id);
      removeVnIds.add(record.id);
      removeRefresh(record.id);
    }

    // Prevent duplications.
    removeVnIds = removeVnIds.toSet().toList();

    // If already synced for once, override the collectionToBeRemoved data to be
    // deleted in the cloud, the next time sync initiated.
    if (syncRepo.isUserSynchronized) {
      localCollection.vnToBeRemovedWhenSync = removeVnIds;
    }

    whenSuccess();

    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _downloadP2Data(List<VnDataPhase01> p1List) async {
    for (VnDataPhase01 p1 in p1List) {
      await ref.read(fetchAndSaveP2DataProvider(p1.id).future);
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _saveCollection({
    required VnSelection selection,
    required List<VnDataPhase01> p1List,
    required Map<String, VnRecord?> vnRecords,
    required void Function(String) saveRefresh,
  }) async {
    final localCollection = ref.read(localCollectionRepoProvider);
    final localVnRepo = ref.read(localVnRepoProvider);

    for (VnDataPhase01 p1 in p1List) {
      final latestRecord = vnRecords[p1.id];

      final saveVnRecord = VnRecord(
        id: p1.id,
        title: p1.title,
        status: _getStatusSelection(selection, latestRecord),
        vote: _getVoteSelection(selection, latestRecord),
        added: _getAddedTimeSelection(selection, latestRecord),
        started: _getStartedTimeSelection(selection, latestRecord),
        finished: _getFinishedTimeSelection(selection, latestRecord),
      );

      // This usecase is useful to save vn item from a search result, since by default search results
      // does not save p1 to the local database.
      if (!localVnRepo.p1Exist(p1.id)) {
        localVnRepo.saveVnContent(p1);
      }

      await localCollection.saveVnRecord(saveVnRecord);
      saveRefresh(p1.id);
    }

    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  String _getStatusSelection(VnSelection selection, VnRecord? latestRecord) {
    // This is confident enough not to check whether the latestRecord.status is valid or not
    // since multiselection mode ("mixed") only occurs for those in collection, which requiring
    // all the collection's status to be never invalid.
    if (latestRecord != null && selection.status == 'Mixed') {
      return latestRecord.status;
    }

    // Such condition exists as a prevention when a multiselection occurred after vns that are yet
    // to be refreshed in the ui after being removed, but still able to be modified, thus expectedly,
    // the latestRecord.status is not valid, so it will be forced to be set in playing category.
    if (selection.status.toLowerCase() == 'mixed') {
      return CollectionStatusCode.playing.name;
    }

    return selection.status;
  }

  int _getVoteSelection(VnSelection selection, VnRecord? latestRecord) {
    if (latestRecord != null && selection.vote == -1) return latestRecord.vote;
    return selection.vote;
  }

  String _getAddedTimeSelection(VnSelection selection, VnRecord? latestRecord) {
    if (latestRecord == null) return "${DateTime.now()}";
    return latestRecord.added!;
  }

  String? _getStartedTimeSelection(VnSelection selection, VnRecord? latestRecord) {
    if (latestRecord != null && selection.started == null) return latestRecord.started;
    return "${selection.started}";
  }

  String? _getFinishedTimeSelection(VnSelection selection, VnRecord? latestRecord) {
    if (latestRecord != null && selection.finished == null) return latestRecord.finished;
    return "${selection.finished}";
  }
}

@riverpod
VnSelectionService vnSelectionService(Ref ref) {
  return VnSelectionService(ref);
}

@Riverpod(dependencies: [vnSelectionService])
Future<void> confirmSelection(
  Ref ref, {
  required List<VnDataPhase01> p1List,
  required Map<String, VnRecord?> vnRecords,
  required VnSelection selection,
  required VoidCallback whenSuccess,
  required Function(Object, StackTrace) whenErr,
  required void Function(String) saveRefresh,
}) async {
  final vnSelectionService = ref.watch(vnSelectionServiceProvider);
  return await vnSelectionService.confirmSelection(
    p1List: p1List,
    vnRecords: vnRecords,
    selection: selection,
    whenSuccess: whenSuccess,
    whenErr: whenErr,
    saveRefresh: saveRefresh,
  );
}

@Riverpod(dependencies: [vnSelectionService])
Future<void> removeSelection(
  Ref ref,
  List<VnRecord?> vnRecords, {
  required VoidCallback whenSuccess,
  required void Function(String) removeRefresh,
}) async {
  final vnSelectionService = ref.watch(vnSelectionServiceProvider);
  return await vnSelectionService.removeSelection(
    vnRecords,
    whenSuccess: whenSuccess,
    removeRefresh: removeRefresh,
  );
}
