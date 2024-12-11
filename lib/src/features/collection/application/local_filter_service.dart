import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_filter_service.g.dart';

class LocalFilterService {
  bool languagesFiltered(List<String>? languagesFilter, Map<String, dynamic> vnRecord) {
    // If there is no specified filter, pass it by (include).
    if (languagesFilter == null || languagesFilter.isEmpty) return true;

    return languagesFilter.any((item) => vnRecord['languages'].contains(item));
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool platformFiltered(List<String>? platformFilter, Map<String, dynamic> vnRecord) {
    // If there is no specified filter, pass it by (include).
    if (platformFilter == null || platformFilter.isEmpty) return true;

    return platformFilter.any((item) => vnRecord['platforms'].contains(item));
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool originlangFiltered(List<String>? olangFilter, Map<String, dynamic> vnRecord) {
    // If there is no specified filter, pass it by (include).
    if (olangFilter == null || olangFilter.isEmpty) return true;

    return olangFilter.any((item) => vnRecord['olang'] == item);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool devStatFiltered(List<int>? devStatusFilter, Map<String, dynamic> vnRecord) {
    // If there is no specified filter, pass it by (include).
    if (devStatusFilter == null || devStatusFilter.isEmpty) return true;

    return devStatusFilter.any((item) => vnRecord['devstatus'] == item);
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool minageFiltered(int? minageFilter, Map<String, dynamic> vnRecord) {
    // If there is no specified filter, pass it by (include).
    if (minageFilter == null || minageFilter == 0) return true;

    // For whatever filter applied, if Vn doesn't have any minage/unknown, then exclude it.
    if (minageFilter != 0 && vnRecord['minage'].isEmpty) return false;

    final int maximumAge = (vnRecord['minage'] as List<int>).reduce((current, next) {
      return (current > next) ? current : next;
    });

    // Adult-only
    if (minageFilter == 18) return maximumAge >= 18;
    return maximumAge < 18; // All-ages
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  bool searchFiltered(Map<String, dynamic> searchFilter) {
    final String? searchQuery = searchFilter['searchQuery'];

    // If there is no specified filter, pass it by (include).
    if (searchQuery == null || searchQuery.trim().isEmpty) return true;

    final List<String> keywords = searchFilter['keywords'];
    final String dataToBeSearched = searchFilter['dataToBeSearched'];

    if (keywords.isEmpty) {
      // Search only for title and aliases.
      return dataToBeSearched.toLowerCase().contains(searchQuery.toLowerCase());
    }

    // Might search for tags or developers.
    return keywords.every((keyword) => dataToBeSearched.toLowerCase().contains(keyword.toLowerCase()));
  }
}

@riverpod
LocalFilterService localFilterService(Ref ref) {
  return LocalFilterService();
}
