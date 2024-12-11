import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/release/vn_detail_releases_lang.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/release/vn_detail_releases_platform.dart';

class VnDetailsContentReleases extends ConsumerWidget {
  const VnDetailsContentReleases({
    super.key,
    required this.p1,
    required this.p2,
  });

  final VnDataPhase01 p1;
  final VnDataPhase02 p2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Release Date
        ShadowText(
          'Release Date',
          fontSize: responsiveUI.own(0.045),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: responsiveUI.own(0.01)),
        ShadowText(p1.released!),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Languages
        SizedBox(height: responsiveUI.own(0.05)),
        VnDetailReleasesLang(p1: p1, p2: p2),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Platforms
        SizedBox(height: responsiveUI.own(0.05)),
        VnDetailReleasesPlatform(p2: p2),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
