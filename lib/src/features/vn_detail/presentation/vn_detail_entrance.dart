import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/generic_error.dart';
import 'package:vndb_lite/src/common_widgets/generic_failure_connection.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/collection_selection/application/collection_selection_remote_service.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/vn_detail_content.dart';

class VnDetailsEntrance extends ConsumerWidget {
  const VnDetailsEntrance({super.key, required this.p1});

  final VnDataPhase01 p1;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Widget get _loading {
    final context = NavigationService.currentContext;

    return Center(
      child: SizedBox(
        height: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? responsiveUI.own(0.5)
            : responsiveUI.own(1),
        width: responsiveUI.own(0.1),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _getError({bool isConnection = false}) {
    final context = NavigationService.currentContext;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Center(
        child: (isConnection) ? const GenericFailureConnection() : const GenericError(),
      ),
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localVnRepo = ref.watch(localVnRepoProvider);

    if (localVnRepo.p2Exist(p1.id)) {
      // GenericSnackBar.hide();

      return ref.watch(getP2Provider(p1.id)).when(
            data: (data) {
              final p2 = data;

              if (p2 == null) return _getError();
              return VnDetailsContent(p1: p1, p2: p2);
            },
            error: (err, st) {
              // print(err);
              // print(st);
              return _getError();
            },
            loading: () => _loading,
          );
    }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

    // This provider will download phase02 and save it to the local repo, but does not
    // return any data (void).
    return ref.watch(fetchAndSaveP2DataProvider(p1.id)).when(
          data: (_) {
            // Get the local downloaded data.
            return ref.watch(getP2Provider(p1.id)).when(
                  data: (data) {
                    final p2 = data;

                    // Assuming no data phase 02 found.
                    if (p2 == null) {
                      return Center(
                        child: ShadowText(
                          "There's nothing here currently :)",
                          fontSize: responsiveUI.catgTitle,
                        ),
                      );
                    }

                    return VnDetailsContent(p1: p1, p2: p2);
                  },
                  error: (err, st) {
                    // print(err);
                    // print(st);
                    return _getError();
                  },
                  loading: () => _loading,
                );
          },
          error: (err, st) {
            // print(err);
            // print(st);
            return _getError(isConnection: true);
          },
          loading: () => _loading,
        );
  }
}
