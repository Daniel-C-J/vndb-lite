// import 'package:flutter/foundation.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';

// TODO create class for this?

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// This file contains helper functions for the remoteSyncRepo class

bool isThereAnyDifference(VnRecord localRecord, Map<String, dynamic> cloudRecord) {
  final recordInLocal = localRecord.toMap();

  // final String vnTitle = cloudRecord['vn']['title'];
  final String cloudStatus = _getVnCloudStatus(cloudRecord);
  final int cloudVote = getVnCloudVote(cloudRecord);
  final String cloudStarted = getVnCloudDate('started', cloudRecord);
  final String cloudFinished = getVnCloudDate('finished', cloudRecord);

  // debugPrint('''Checking VN ${myVnFromCloud['vn']['title']}...''');

  // debugPrint('$vnTitle status in dbCloud: $cloudStatus');
  // debugPrint('$vnTitle status in dbLocal: ${recordInLocal['status']}');

  // debugPrint('$vnTitle vote in dbCloud: $cloudVote');
  // debugPrint('$vnTitle vote in dbLocal: ${recordInLocal['vote']}');

  // debugPrint('$vnTitle started in dbCloud: $cloudStarted');
  // debugPrint('$vnTitle started in dbLocal: ${_getComparableLocalVnDate('started', recordInLocal)}');

  // debugPrint('$vnTitle finished in dbCloud: $cloudFinished');
  // debugPrint('$vnTitle finished in dbLocal: ${_getComparableLocalVnDate('finished', recordInLocal)}');

  if (localRecord.status == cloudStatus &&
      localRecord.vote == cloudVote &&
      _getComparableLocalVnDate('started', recordInLocal) == cloudStarted &&
      _getComparableLocalVnDate('finished', recordInLocal) == cloudFinished) {
    return false;
  }

  return true;
}

String _getVnCloudStatus(Map<String, dynamic> cloudRecord) {
  return cloudRecord['labels'][0]['label'].toString().toLowerCase();
}

int getVnCloudVote(Map<String, dynamic> cloudRecord) {
  if (cloudRecord['vote'] != null && cloudRecord['vote'] != 0) return (cloudRecord['vote'] / 10).toInt();
  return 0;
}

String getVnCloudDate(String whatDate, Map<String, dynamic> cloudRecord) {
  if (whatDate == 'added') {
    return "${DateTime.fromMillisecondsSinceEpoch((cloudRecord[whatDate] ?? 0) * 1000)}";
  }

  // Will return string of null to be easily comparable.
  if (cloudRecord[whatDate] == null ||
      cloudRecord[whatDate] == 'null' ||
      cloudRecord[whatDate]?.contains('1970-01-01')) {
    return 'null';
  }

  return cloudRecord[whatDate].toString().substring(0, 10);
}

String _getComparableLocalVnDate(String whatDate, Map<String, dynamic> localRecord) {
  if (localRecord[whatDate] == null ||
      localRecord[whatDate].contains("null") ||
      localRecord[whatDate].contains('1970-01-01')) {
    return "null";
  }

  return localRecord[whatDate].substring(0, 10);
}

bool localVnHasVote(VnRecord localRecord) {
  return localRecord.vote != 0;
}

String getLocalVnDate(String whatDate, Map<String, dynamic> localRecord) {
  // 1970-01-01 is just a placeholder.
  if (localRecord[whatDate].contains("null") || localRecord[whatDate] == null) return '1970-01-01';
  return localRecord[whatDate].substring(0, 10);
}


//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//


