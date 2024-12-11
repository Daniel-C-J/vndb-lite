import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sort_filter_service.g.dart';

class SortFilterService {
  SortFilterService(this.ref);

  final Ref ref;
}

@riverpod
SortFilterService sortFilterService(Ref ref) {
  return SortFilterService(ref);
}
