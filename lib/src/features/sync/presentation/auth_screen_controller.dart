import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/sync/data/local/local_sync_repo.dart';
import 'package:vndb_lite/src/features/sync/data/remote/remote_sync_repo.dart';
import 'package:vndb_lite/src/features/sync/domain/user_identity.dart';

part 'auth_screen_controller.g.dart';

@riverpod
class AuthScreenController extends _$AuthScreenController {
  @override
  UserIdentity? build() {
    return _userIdentity;
  }

  UserIdentity? get _userIdentity => ref.read(localSyncRepoProvider).userIdentity;

  void userIdentityFromResponse(Map<String, dynamic> responseData, String authToken) {
    final uId = UserIdentity(
      authToken: authToken,
      id: responseData['id'],
      username: responseData['username'],
    );

    ref.read(localSyncRepoProvider).userIdentity = uId;
  }

  bool isUserSynced() => ref.read(localSyncRepoProvider).isUserSynchronized;
  bool isUserAuthed() => ref.read(localSyncRepoProvider).isUserSynchronized;

  Future<Response> authenticate(String authToken) async {
    final remoteSyncRepo = ref.read(remoteSyncRepoProvider);
    return await remoteSyncRepo.authenticate(authToken);
  }
}
