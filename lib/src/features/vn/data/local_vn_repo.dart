import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn/domain/p3.dart';

part 'local_vn_repo.g.dart';

class LocalVnRepo {
  const LocalVnRepo(this._sharedPref);

  final SharedPreferences _sharedPref;

  bool p1Exist(String vnId) {
    return _sharedPref.containsKey('${DBKeys.P1}$vnId');
  }

  bool p2Exist(String vnId) {
    return _sharedPref.containsKey('${DBKeys.P2}$vnId');
  }

  bool p3Exist(String vnId) {
    return _sharedPref.containsKey('${DBKeys.P3}$vnId');
  }

  String? getRawP1(String vnId) {
    return _sharedPref.getString('${DBKeys.P1}$vnId');
  }

  String? getRawP2(String vnId) {
    return _sharedPref.getString('${DBKeys.P2}$vnId');
  }

  String? getRawP3(String vnId) {
    return _sharedPref.getString('${DBKeys.P3}$vnId');
  }

  Future<VnDataPhase01?> getP1(String vnId) async {
    if (!p1Exist(vnId)) return null;
    return VnDataPhase01.fromJson(getRawP1(vnId)!);
  }

  Future<VnDataPhase02?> getP2(String vnId) async {
    if (!p2Exist(vnId)) return null;
    return VnDataPhase02.fromJson(getRawP2(vnId)!);
  }

  Future<VnDataPhase03?> getP3(String vnId) async {
    if (!p3Exist(vnId)) return null;
    return VnDataPhase03.fromJson(getRawP3(vnId)!);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> saveVnContent(VnDataPhase vnData) async {
    if (vnData is VnDataPhase01) {
      await _sharedPref.setString('${DBKeys.P1}${vnData.id}', json.encode(vnData.toMap()));
      //
    } else if (vnData is VnDataPhase02) {
      await _sharedPref.setString('${DBKeys.P2}${vnData.id}', json.encode(vnData.toMap()));
      //
    } else if (vnData is VnDataPhase03) {
      //
      await _sharedPref.setString('${DBKeys.P3}${vnData.id}', json.encode(vnData.toMap()));
    }

    _sharedPref.reload();
    return;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> removeVnContent({required int phase, required String vnId}) async {
    if (phase == 1) {
      await _sharedPref.remove('${DBKeys.P1}$vnId');
      //
    } else if (phase == 2) {
      await _sharedPref.remove('${DBKeys.P2}$vnId');
      //
    } else if (phase == 3) {
      await _sharedPref.remove('${DBKeys.P3}$vnId');
    } else {
      // TODO throw grenade (jk, exception).
    }

    _sharedPref.reload();
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}

@Riverpod(dependencies: [sharedPref])
LocalVnRepo localVnRepo(Ref ref) {
  final sharedPref = ref.watch(sharedPrefProvider);
  return LocalVnRepo(sharedPref);
}

@Riverpod(dependencies: [localVnRepo])
Future<VnDataPhase01?> getP1(Ref ref, String vnId) async {
  final localVnRepo = ref.watch(localVnRepoProvider);
  return await localVnRepo.getP1(vnId);
}

@Riverpod(dependencies: [localVnRepo])
Future<VnDataPhase02?> getP2(Ref ref, String vnId) async {
  final localVnRepo = ref.watch(localVnRepoProvider);
  return await localVnRepo.getP2(vnId);
}

@Riverpod(dependencies: [localVnRepo])
Future<VnDataPhase03?> getP3(Ref ref, String vnId) async {
  final localVnRepo = ref.watch(localVnRepoProvider);
  return await localVnRepo.getP3(vnId);
}
