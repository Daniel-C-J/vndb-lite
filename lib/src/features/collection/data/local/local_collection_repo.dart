// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vndb_lite/src/constants/local_storage_constants.dart';
import 'package:vndb_lite/src/core/app/shared_prefs.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';
import 'package:vndb_lite/src/features/home/data/local/local_home_repo.dart';

part 'local_collection_repo.g.dart';

// TODO do remember to put class abstractions... :)

class LocalCollectionRepo {
  const LocalCollectionRepo(this._sharedPref, this._localHomeRepo);

  final SharedPreferences _sharedPref;
  final LocalHomeRepoImpl _localHomeRepo;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> saveVnRecord(VnRecord vnRecord) async {
    final int? sectionRange = getSectionFromId(vnRecord.id);

    if (sectionRange == null) {
      // TODO do this more.
      throw Exception('Bad sectionRange. Please check the typical vn id (e.g v12345).');
    }

    final List<String> collection =
        _sharedPref.getStringList('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange') ?? [];

    // In order to prevent duplication, if vn record exists, then remove first.
    collection.removeWhere((record) => record.contains('"${vnRecord.id}"'));
    collection.add(json.encode(vnRecord.toMap()));

    // Override data
    _sharedPref.setStringList('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange', collection);
    _sharedPref.reload();

    _updateSectionRangeList(vnRecord.id);
    _localHomeRepo.insertCollectionPreview(vnRecord.id);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void removeVnRecord(String vnId) {
    final int? sectionRange = getSectionFromId(vnId);

    if (sectionRange == null) {
      throw Exception('Bad sectionRange. Please check the typical vn id (e.g v12345).');
    }

    // If section never exists, just ignore it.
    if (!_sharedPref.containsKey('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange')) return;

    final List<String> collection =
        _sharedPref.getStringList('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange') ?? [];

    collection.removeWhere((vnRecord) => vnRecord.contains('"$vnId"'));

    _sharedPref.setStringList('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange', collection);
    _sharedPref.reload();

    _updateSectionRangeList(vnId);
    _localHomeRepo.popCollectionPreview(vnId);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  void _updateSectionRangeList(String vnId) {
    final List<String> currentSectionRangeLists =
        _sharedPref.getStringList(DBKeys.SAVED_COLLECTION_SECTIONS) ?? [];
    final int sectionRange = getSectionFromId(vnId)!;

    if (currentSectionRangeLists.contains('$sectionRange')) {
      final VnRecord? vnInCollection = getVnRecordFromId(vnId);

      // If a section found have nothing inside, then delete the section.
      if (vnInCollection == null) {
        _sharedPref.remove('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange');
        currentSectionRangeLists.remove('$sectionRange');
      }
      //
    } else {
      //
      currentSectionRangeLists.add('$sectionRange');
    }

    _sharedPref.setStringList(DBKeys.SAVED_COLLECTION_SECTIONS, currentSectionRangeLists);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  VnRecord? getVnRecordFromId(String vnId) {
    final int? sectionRange = getSectionFromId(vnId);
    final List<String> collection = getVnRecordsFromSection('$sectionRange');

    final rawVnRecord = collection.firstWhereOrNull((savedVn) => savedVn.contains('"$vnId"'));

    if (rawVnRecord == null) return null;
    return VnRecord.fromMap(json.decode(rawVnRecord));
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  int? getSectionFromId(String vnId) {
    final int vnRecordsPerSection = 100;

    // Expected raw vnId is one letter prefix, the rest are numbers. (v34522)
    final int? extractedVnId = int.tryParse(vnId.toLowerCase().replaceAll("v", ""));
    if (extractedVnId == null) return null;

    // (~/) is dart's floor division operator syntax, not to confuse with (%) modulo.
    final int sectionCode = extractedVnId ~/ vnRecordsPerSection;
    if (sectionCode == 0) return vnRecordsPerSection;

    // Added one to prevent having a sectionRange with 200 items, since V100 used for those
    // id under 100 (see above), and if sectionCode == 1 comes to play, it will also have the same
    // sectionRange of V100 (sectionCode * 100), so afterwards, the sectionRange must be incremented
    // specifically by one except for sectionCode of 0.
    return (sectionCode + 1) * vnRecordsPerSection;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  List<String> getVnRecordsFromSection(String sectionRange) {
    return _sharedPref.getStringList('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange') ?? [];
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  List<String> get rawAllRecords {
    final List<String> collectionSections = _sharedPref.getStringList(DBKeys.SAVED_COLLECTION_SECTIONS) ?? [];
    List<String> fullCollectionList = [];

    for (String sectionRange in collectionSections) {
      final List<String> collectionPerSection = getVnRecordsFromSection(sectionRange);

      // Appending the previous results.
      if (collectionPerSection.isNotEmpty) {
        fullCollectionList = [...fullCollectionList, ...collectionPerSection];
      }
    }

    return fullCollectionList;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> removeAllCollection({required bool includeSync}) async {
    final List<String> collectionSections = _sharedPref.getStringList(DBKeys.SAVED_COLLECTION_SECTIONS) ?? [];
    final List<String> removeVnIds = vnToBeRemovedWhenSync;

    for (String sectionRange in collectionSections) {
      //
      if (_sharedPref.containsKey('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange')) {
        _sharedPref.remove('${DBKeys.SAVED_COLLECTION_OF_SECTION_V}$sectionRange');
      }
    }

    // A case scenario where user already once synchronized with the server, and for some reason,
    // they want to delete or remove all of their collections, then the below operation must also
    // be executed, in order to also remove those collections in their cloud account too.
    // But ONLY will happen, if they're clicking the sync button again.
    if (includeSync) {
      final allRecords = await getAllRecords();
      for (VnRecord record in allRecords) {
        removeVnIds.add(record.id);
      }

      vnToBeRemovedWhenSync = removeVnIds;
    }

    _sharedPref.remove(DBKeys.SAVED_COLLECTION_SECTIONS);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
  void cleanVnToBeRemovedWhenSync() {
    _sharedPref.setStringList(DBKeys.VN_RECORDS_TO_BE_REMOVED, []);
    _sharedPref.reload();
  }

  set vnToBeRemovedWhenSync(List<String> vnId) {
    List<String> vns = _sharedPref.getStringList(DBKeys.VN_RECORDS_TO_BE_REMOVED) ?? [];
    vns = [...vns, ...vnId];

    _sharedPref.setStringList(DBKeys.VN_RECORDS_TO_BE_REMOVED, vns);
    _sharedPref.reload();
  }

  List<String> get vnToBeRemovedWhenSync {
    return _sharedPref.getStringList(DBKeys.VN_RECORDS_TO_BE_REMOVED) ?? [];
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  List<String> getRawRecords(List<VnRecord> records) {
    final List<String> tempDB = [];
    for (VnRecord vnRecord in records) {
      tempDB.add(json.encode(vnRecord.toMap()));
    }

    return tempDB;
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<List<VnRecord>> getAllRecords([List<String>? partialCollection]) async {
    final List<String> dbCollection = partialCollection ?? rawAllRecords;

    return [
      for (var rawRecord in dbCollection) VnRecord.fromMap(json.decode(rawRecord)),
    ];
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}

@Riverpod(dependencies: [sharedPref, localHomeRepo])
LocalCollectionRepo localCollectionRepo(Ref ref) {
  final sharedPref = ref.watch(sharedPrefProvider);
  final localHomeRepo = ref.watch(localHomeRepoProvider);
  return LocalCollectionRepo(sharedPref, localHomeRepo);
}
