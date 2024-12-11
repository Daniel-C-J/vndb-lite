import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/sync/domain/user_identity.dart';

part 'local_sync_repo.g.dart';

class LocalSyncRepo {
  LocalSyncRepo(this._sharedPref);

  final SharedPreferences _sharedPref;

  bool get isUserSynchronized => _sharedPref.getBool(DBKeys.USER_SYNCED) ?? false;

  set isUserSynchronized(bool value) {
    _sharedPref.setBool(DBKeys.USER_SYNCED, value);
    _sharedPref.reload();
  }

  set userIdentity(UserIdentity? uId) {
    if (uId != null) {
      _sharedPref.setString(DBKeys.USER_IDENTITY, json.encode(uId.toMap()));
      _sharedPref.reload();
    }
  }

  UserIdentity? get userIdentity {
    final uId = _sharedPref.getString(DBKeys.USER_IDENTITY);

    if (uId != null) return UserIdentity.fromMap(json.decode(uId));
    return null;
  }

  void reset() {
    _sharedPref.remove(DBKeys.USER_IDENTITY);
    _sharedPref.remove(DBKeys.USER_SYNCED);

    _sharedPref.reload();
  }
}

@Riverpod(dependencies: [sharedPref])
LocalSyncRepo localSyncRepo(Ref ref) {
  final sharedPref = ref.watch(sharedPrefProvider);
  return LocalSyncRepo(sharedPref);
}
