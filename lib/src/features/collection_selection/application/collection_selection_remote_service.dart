import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/data/remote_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';

part 'collection_selection_remote_service.g.dart';

@Riverpod(dependencies: [remoteVnRepo, localVnRepo])
Future<void> fetchAndSaveP2Data(Ref ref, String vnId) async {
  final remoteVnRepo = ref.watch(remoteVnRepoProvider);
  final localVnRepo = ref.watch(localVnRepoProvider);

  // Fetch request data.
  await Future.wait([
    remoteVnRepo.fetchP2aData(vnId),
    remoteVnRepo.fetchP2bData(vnId),
  ]).then((value) {
    final result1 = value[0].data['results']?[0];
    final result2 = value[1].data['results'];

    // Check the response whether there's an error or empty.
    if (result1.isEmpty || result1 == null || result2.isEmpty || result2 == null) return;

    // Format the response and save to the local db if no error and not empty.
    final Map<String, dynamic> newResult = {...result1, ...VnDataPhase02.processAdditionalP2(result2)};
    localVnRepo.saveVnContent(VnDataPhase02.fromMap(newResult));
  });
}
