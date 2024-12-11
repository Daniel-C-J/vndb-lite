import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/generic_error.dart';
import 'package:vndb_lite/src/common_widgets/generic_failure_connection.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn_detail/application/vn_detail_relations._service.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/relations/vn_detail_relations_content.dart';

class VnDetailsContentRelationsEntrance extends ConsumerWidget {
  const VnDetailsContentRelationsEntrance({super.key, required this.vnId});

  final String vnId;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget get _loading {
    return Padding(
      padding: EdgeInsets.only(top: responsiveUI.own(0.1)),
      child: SizedBox(
        height: responsiveUI.own(0.2),
        width: responsiveUI.own(0.2),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _getError({bool isConnection = false}) {
    return Container(
      padding: EdgeInsets.only(top: responsiveUI.own(0.1)),
      child: Center(
        child: (isConnection) ? const GenericFailureConnection() : const GenericError(),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localVnRepo = ref.watch(localVnRepoProvider);

    if (localVnRepo.p3Exist(vnId)) {
      // GenericSnackBar.hide();

      return ref.watch(getP3Provider(vnId)).when(
            data: (data) {
              final p3 = data;
              return VnDetailsContentRelations(p3: p3!);
            },
            error: (err, st) {
              return _getError();
            },
            loading: () => _loading,
          );
    }
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

    // This provider will download phase03 and save it to the local repo, but does not
    // return any data (void).
    return ref.watch(fetchAndSaveP3DataProvider(vnId)).when(
          data: (_) {
            // Get the local downloaded data.
            return ref.watch(getP3Provider(vnId)).when(
                  data: (data) {
                    final p3 = data;

                    // Assuming no data phase 03 found.
                    if (p3 == null) {
                      return Center(
                        child: ShadowText(
                          "There's nothing here currently :)",
                          fontSize: responsiveUI.catgTitle,
                          color: Colors.red,
                        ),
                      );
                    }

                    return VnDetailsContentRelations(p3: p3);
                  },
                  error: (err, st) {
                    return _getError();
                  },
                  loading: () => _loading,
                );
          },
          error: (err, st) {
            return _getError(isConnection: true);
          },
          loading: () => _loading,
        );
  }
}
