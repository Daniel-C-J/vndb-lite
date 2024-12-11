import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/core/network/network_helper.dart';
import 'package:vndb_lite/src/features/_base/presentation/upper_parts/buttons/refresh_button.dart';
import 'package:vndb_lite/src/features/collection/application/collection_vn_service.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection/data/local/local_collection_repo.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';
import 'package:vndb_lite/src/util/local_notification.dart';
import 'package:vndb_lite/src/features/sync/data/local/local_sync_repo.dart';
import 'package:vndb_lite/src/features/sync/data/remote/remote_sync_repo.dart';
import 'package:vndb_lite/src/features/sync/data/remote/remote_sync_repo_helper.dart';
import 'package:vndb_lite/src/features/sync/domain/user_identity.dart';
import 'package:vndb_lite/src/features/sync/presentation/auth_screen_controller.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';

part 'sync_service.g.dart';

class SyncService {
  SyncService(this.ref, {required this.snackbar});

  final Ref ref;
  final void Function(String text, {required IconData icon, required Color iconColor}) snackbar;

  // A placeholder.
  Timer _refreshCollection = Timer(const Duration(days: 365), () {});

  Future<void> sync({required bool keepVns, required VoidCallback whenDownloadingAndSaving}) async {
    // Does not do any process whatsoever if there is no internet connection.
    final hasConnection = await ref.read(networkInfoProvider).isConnected;
    if (!hasConnection) return returnError(status: 0);

    // Checking whether user already authenticated or not.
    final userIdentity = ref.read(authScreenControllerProvider);
    if (userIdentity == null) return returnError(status: 2);

    // User friendly (should be) message.
    localNotification.showSyncNotification(status: 0);
    snackbar(
      'Synchronizing account...',
      icon: Icons.sync,
      iconColor: App.themeColor.tertiary,
    );

    if (!await _isTokenValid(userIdentity)) return returnError(status: 1);

    try {
      // Sync process begin
      final remoteSyncRepo = ref.read(remoteSyncRepoProvider);

      // 1. Remove Vns in the cloud collection that is meant to be removed from the local collection after once
      // successfully sync. (Not the first time)
      remoteSyncRepo.removeVns(userIdentity.authToken);

      // 2. Fetch all Vns data from the cloud collection
      await Future.delayed(const Duration(milliseconds: 1500));
      final List cloudRecords = await remoteSyncRepo.getLatestDataFromCloud(userIdentity.id);

      // If choosing not to keepVns that the current db will be ignored as in empty.
      List<VnRecord> localRecords = [];

      // 3. If user chose to keep his/her Vns from the local collection (default), then post and patch
      // the vns to the cloud collection.
      if (keepVns) {
        localRecords = await ref.read(localCollectionRepoProvider).getAllRecords();
        if (localRecords.isNotEmpty) {
          await remoteSyncRepo.postPatchData(
            localRecords,
            cloudRecords,
            authToken: userIdentity.authToken,
            keepVns: keepVns,
          );
        }
      }

      // 4. After all data has been posted and patched to the cloud, it is time to fetch them back to make
      // sure data is correct and served locally.
      await getDataPhases(localRecords, cloudRecords, whenDownloadingAndSaving);

      // 5. Success
      _successfullySynchronized(whenDownloadingAndSaving);
      return;
      //
    } catch (e) {
      debugPrint(e.toString());
      returnError();
      //
    } finally {
      _refreshCollection.cancel();
      await AppBarRefreshButton.tap(); // Forbidden Ref
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  VnRecord _generateVnRecord(
    VnRecord? localRecord,
    Map<String, dynamic> cloudRecord,
  ) {
    // Will use localRecord instead of cloud, making the procedure local data oriented
    return VnRecord(
      id: cloudRecord['id'],
      title: (localRecord != null) ? localRecord.title : cloudRecord['vn']['title'],
      status: ((localRecord != null) ? localRecord.status : cloudRecord['status']).toLowerCase(),
      vote: (localRecord != null) ? localRecord.vote : getVnCloudVote(cloudRecord),
      added: (localRecord != null) ? localRecord.added : getVnCloudDate('added', cloudRecord),
      started: (localRecord != null) ? localRecord.started : getVnCloudDate('started', cloudRecord),
      finished: (localRecord != null) ? localRecord.finished : getVnCloudDate('finished', cloudRecord),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> getDataPhases(
    List<VnRecord> localRecords,
    List cloudRecords,
    VoidCallback whenDownloadingAndSaving,
  ) async {
    final List<VnRecord> vnRecords = [];

    for (Map<String, dynamic> cloudRecord in cloudRecords) {
      final VnRecord? localRecord = localRecords.firstWhereOrNull((record) => record.id == cloudRecord['id']);

      // This eliminates strange status label that is not defined in the vn status label.
      final List labels = cloudRecord['labels'].where((label) {
        return COLLECTION_STATUS_DATA.keys.contains(label['label'].toString().toLowerCase());
      }).toList();

      // Injecting label to cloudrecord's status to make it available to process.
      cloudRecord['status'] = labels[0]['label'];

      vnRecords.add(_generateVnRecord(localRecord, cloudRecord));
    }

    // Duplication removal
    final ids = vnRecords.map<String>((e) => e.id).toSet();
    vnRecords.retainWhere((VnRecord x) {
      return ids.remove(x.id);
    });

    // After saving all of the records, now's the time to save each phase 01
    // and phase 02 data of the vn.
    await _downloadAndSaveData(vnRecords, whenDownloadingAndSaving);
    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> _downloadAndSaveData(List<VnRecord> vnRecords, VoidCallback whenDownloadingAndSaving) async {
    final localVnRepo = ref.read(localVnRepoProvider);
    final collectionRepo = ref.read(localCollectionRepoProvider);

    _refreshCollection = Timer.periodic(const Duration(milliseconds: 6000), (_) async {
      whenDownloadingAndSaving();
    });

    for (VnRecord record in vnRecords) {
      // Checks locally if either p1 or p2 data exists or not, if not will download both and save.
      if (!localVnRepo.p1Exist(record.id) || !localVnRepo.p2Exist(record.id)) {
        await ref.read(validateVnAndSaveToLocalProvider(record.id).future);
      }

      // Saves vn record if data exists in local collection.
      await collectionRepo.saveVnRecord(record);
      await Future.delayed(const Duration(milliseconds: 2000));

      // Paranoid mode, a recheck.
      if (collectionRepo.getVnRecordFromId(record.id) == null) {
        await collectionRepo.saveVnRecord(record);
      }

      final title = (record.title.length >= 14) ? '${record.title.substring(0, 12)}...' : record.title;
      if (!localVnRepo.p1Exist(record.id) || !localVnRepo.p2Exist(record.id)) {
        snackbar(
          "Failed to sync $title",
          icon: Icons.error,
          iconColor: Colors.red,
        );
      } else {
        snackbar(
          "$title synced! ",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      }
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void returnError({int status = 0}) async {
    // TODO enhance this.
    return await Future.delayed(const Duration(milliseconds: 400), () {
      if (status == 0) {
        snackbar(
          'Connection Error. Try again later, ok?',
          icon: Icons.error,
          iconColor: Colors.red,
        );
        //
      } else if (status == 1) {
        snackbar(
          'Bad Token Permissions',
          icon: Icons.error,
          iconColor: Colors.red,
        );
        //
      } else {
        snackbar(
          'Error. Please try to re-authenticate.',
          icon: Icons.error,
          iconColor: Colors.red,
        );
      }

      // Shows statusbar notification error.
      localNotification.showSyncNotification(status: -1);
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<bool> _isTokenValid(UserIdentity userIdentity) async {
    try {
      final response =
          await ref.read(authScreenControllerProvider.notifier).authenticate(userIdentity.authToken);

      if (response.data['permissions'].contains('listread') &&
          response.data['permissions'].contains('listwrite')) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _successfullySynchronized(VoidCallback whenSuccess) {
    ref.read(localSyncRepoProvider).isUserSynchronized = true;

    Future.delayed(const Duration(milliseconds: 3500), () {
      whenSuccess();
      localNotification.showSyncNotification(status: 1);
      snackbar(
        'Synchronization successful',
        icon: Icons.sync,
        iconColor: App.themeColor.tertiary,
      );
    });

    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}

@riverpod
SyncService syncService(
  Ref ref, {
  required void Function(String, {required IconData icon, required Color iconColor}) snackbar,
}) {
  return SyncService(ref, snackbar: snackbar);
}
