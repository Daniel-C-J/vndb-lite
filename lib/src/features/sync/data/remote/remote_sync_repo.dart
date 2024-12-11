import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/constants/network_constant.dart';
import 'package:vndb_lite/src/core/network/api_service.dart';
import 'package:vndb_lite/src/features/collection/data/collection_status_data.dart';
import 'package:vndb_lite/src/features/collection/data/local/local_collection_repo.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/sync/data/remote/remote_sync_repo_helper.dart';

part 'remote_sync_repo.g.dart';

class RemoteSyncRepo {
  RemoteSyncRepo(this._apiService, this._collection);

  final ApiService _apiService;
  final LocalCollectionRepo _collection;

  static const authEndpoint = "/kana/authinfo";

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<Response> authenticate(String token) async {
    return await _apiService.get(
      endPoint: authEndpoint,
      options: Options(
        headers: {'Authorization': 'token $token'},
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> removeVns(String token) async {
    for (String vnId in _collection.vnToBeRemovedWhenSync) {
      await Future.delayed(const Duration(milliseconds: 400), () async {
        await _apiService.delete(
          endPoint: "/kana/ulist/$vnId",
          options: Options(
            contentType: 'application/json',
            headers: {'Authorization': 'token $token'},
          ),
        );
      });
    }

    // Clear data when done.
    _collection.cleanVnToBeRemovedWhenSync();
    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  // List of api call responses, meant to store future data, and outside any function
  // to prevent being overwritten.
  List _resultFromAPI = [];

  // Page of results.
  int _page = 1;

  getLatestDataFromCloud(String userId) async {
    // Get the collections from the cloud.
    final Response requestToServer = await _apiService.post(
      endPoint: "/kana/ulist",
      data: {
        "user": userId,
        "sort": SortableCode.added.name,
        "fields": APIConstants.USER_VNS_FIELDS,
        "results": Default.MAX_VN_SEARCH_RESULT,
        "page": _page
      },
    );

    _resultFromAPI = [..._resultFromAPI, ...requestToServer.data['results']];

    // Repeating again until there is no 'more' left.
    if (requestToServer.data['more']) {
      _page++;
      return getLatestDataFromCloud(userId);
    }

    // Back to default
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _resultFromAPI.clear();
      _page = 1;
    });

    return _resultFromAPI;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> postPatchData(List<VnRecord> localRecords, List cloudRecords,
      {required String authToken, required bool keepVns}) async {
    //
    for (VnRecord localRecord in localRecords) {
      final int statusId = COLLECTION_STATUS_DATA[localRecord.status.toLowerCase()]!.id;
      final cloudRecord = cloudRecords.firstWhereOrNull((idx) => idx['id'] == localRecord.id);

      // If local record exists in the cloud.
      if (cloudRecord != null) {
        // Preparing for comparing data to check for any changes.
        if (isThereAnyDifference(localRecord, cloudRecord)) {
          // For behavioural issue of the API (or maybe I was drunk at that time, jk), such logic happen:
          // If vote exists in vn, then delete the vn first, and then repost the record.
          if (localVnHasVote(localRecord)) {
            await delete(cloudRecord['id'], authToken: authToken);
          }

          await post(localRecord, authToken: authToken, statusId: statusId);
          continue;
        }

        continue;
        //
      } else {
        // If not exist in the cloud, then post the data
        await post(localRecord, authToken: authToken, statusId: statusId);
      }
    }

    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> delete(String vnId, {required String authToken}) async {
    return await Future.delayed(const Duration(milliseconds: 1200), () async {
      await _apiService.delete(
        endPoint: "/kana/ulist/$vnId",
        options: Options(
          contentType: 'application/json',
          headers: {'Authorization': 'token $authToken'},
        ),
      );
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> post(VnRecord localRecord, {required String authToken, required int statusId}) async {
    return await Future.delayed(const Duration(milliseconds: 1200), () async {
      // Despite how the method name is "patch", it still works logically as if posting
      // a new data related to the user, that is, posting new vnrecord related to the user.
      await _apiService.patch(
        endPoint: "/kana/ulist/${localRecord.id}",
        options: Options(
          contentType: 'application/json',
          headers: {'Authorization': 'token $authToken'},
        ),
        data: {
          'labels': [statusId],
          // If vote data does exist.
          if (localVnHasVote(localRecord)) 'vote': localRecord.vote * 10,
          'started': getLocalVnDate('started', localRecord.toMap()),
          'finished': getLocalVnDate('finished', localRecord.toMap()),
        },
      );
    });
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}

@Riverpod(dependencies: [apiService, localCollectionRepo])
RemoteSyncRepo remoteSyncRepo(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  final localCollectionRepo = ref.watch(localCollectionRepoProvider);
  return RemoteSyncRepo(apiService, localCollectionRepo);
}

@Riverpod(dependencies: [remoteSyncRepo])
Future<Response> authenticate(Ref ref, String token) async {
  final remoteSyncRepo = ref.watch(remoteSyncRepoProvider);
  return await remoteSyncRepo.authenticate(token);
}
