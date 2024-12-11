import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/data/remote_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';

part 'collection_vn_service.g.dart';

@Riverpod(dependencies: [remoteVnRepo, localVnRepo])
Future<bool> validateVnAndSaveToLocal(Ref ref, String vnId) async {
  bool valid = false;

  final localVnRepo = ref.read(localVnRepoProvider);
  final remoteVnRepo = ref.read(remoteVnRepoProvider);

  // Fetch request data.
  await Future.wait([
    remoteVnRepo.fetchP1Data(vnId),
    remoteVnRepo.fetchP2aData(vnId),
    remoteVnRepo.fetchP2bData(vnId),
  ]).then(
    (value) async {
      final result1 = value[0].data['results']?[0];
      final result2a = value[1].data['results']?[0];
      final result2b = value[2].data['results'];

      // Check the response whether there's an error or empty.
      if (result1.isEmpty ||
          result1 == null ||
          result2a.isEmpty ||
          result2a == null ||
          result2b.isEmpty ||
          result2b == null) {
        // TODO this might become a problem, maybe throw instead?
        return;
      }

      // Format the response and save to the local db if no error and not empty.
      final Map<String, dynamic> formattedResult = {
        ...result1,
        ...result2a,
        ...VnDataPhase02.processAdditionalP2(result2b),
      };

      final p1 = VnDataPhase01.fromMap(formattedResult);
      localVnRepo.saveVnContent(p1);

      final p2 = VnDataPhase02.fromMap(formattedResult);
      localVnRepo.saveVnContent(p2);

      // Final check.
      await Future.delayed(const Duration(milliseconds: 600), () {
        if (localVnRepo.p1Exist(vnId) && localVnRepo.p2Exist(vnId)) valid = true;
      });
    },
  );

  return valid;
}
