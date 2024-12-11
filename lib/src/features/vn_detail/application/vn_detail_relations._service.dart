import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/data/remote_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p3.dart';

part 'vn_detail_relations._service.g.dart';

@Riverpod(dependencies: [remoteVnRepo, localVnRepo])
Future<void> fetchAndSaveP3Data(Ref ref, String vnId) async {
  final remoteVnRepo = ref.watch(remoteVnRepoProvider);
  final localVnRepo = ref.watch(localVnRepoProvider);

  // Fetch request data.
  final response = await remoteVnRepo.fetchP3Data(vnId);
  final result = response.data['results'];

  // Check the response whether there's an error or empty, if true, then just return or exit.
  if (result.isEmpty || result == null) return;

  // If false, then save the contents.
  localVnRepo.saveVnContent(VnDataPhase03.fromMap(result[0]));

  for (Map<String, dynamic> relation in result[0]['relations']) {
    localVnRepo.saveVnContent(VnDataPhase01.fromMap(relation));
  }
}
