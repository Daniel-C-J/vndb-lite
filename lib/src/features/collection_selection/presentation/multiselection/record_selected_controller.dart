import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';

part 'record_selected_controller.g.dart';

@Riverpod(keepAlive: true)
class RecordSelectedController extends _$RecordSelectedController {
  @override
  List<String> build() {
    return [];
  }

  set record(List<String> value) => state = value;

  /// This method talks to vn repository to format the raw data into a classified model
  Future<List<VnDataPhase01>> convertToP1() async {
    final localVnRepo = ref.read(localVnRepoProvider);
    return [for (String id in state) (await localVnRepo.getP1(id))!];
  }
}
