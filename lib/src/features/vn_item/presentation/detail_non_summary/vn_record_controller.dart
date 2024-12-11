import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/collection/data/local/local_collection_repo.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';

part 'vn_record_controller.g.dart';

@Riverpod(keepAlive: true)
class VnRecordController extends _$VnRecordController {
  @override
  VnRecord? build(String vnId) {
    return ref.watch(localCollectionRepoProvider).getVnRecordFromId(vnId);
  }

  void refresh() {
    if (state != null) state = state!.copyWith();
  }

  void importRecord(VnRecord? record) => state = record;
}
