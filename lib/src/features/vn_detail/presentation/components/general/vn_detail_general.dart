import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/general/vn_detail_general_screenshots.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/general/vn_detail_general_tags.dart';

class VnDetailsContentGeneral extends StatelessWidget {
  const VnDetailsContentGeneral({
    super.key,
    required this.p1,
    required this.p2,
  });

  final VnDataPhase01 p1;
  final VnDataPhase02 p2;

  String get _minimumAge {
    final minage = p2.minage;

    if (minage == null || minage.isEmpty) return 'Unknown';
    if (minage.length == 2) return '${minage[0]}/${minage[1]}';
    return '${minage[0]}';
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Aliases
        ShadowText(
          'Aliases',
          fontSize: responsiveUI.own(0.045),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: responsiveUI.own(0.01)),
        ShadowText(
          (p2.aliases!.isEmpty) ? '--' : p2.aliases!.join(' | '),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Age
        SizedBox(height: responsiveUI.own(0.05)),
        ShadowText(
          'Age',
          fontSize: responsiveUI.own(0.045),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: responsiveUI.own(0.01)),
        ShadowText('Minimum age: $_minimumAge'),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Description
        SizedBox(height: responsiveUI.own(0.05)),
        ShadowText(
          'Description',
          fontSize: responsiveUI.own(0.045),
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: responsiveUI.own(0.01)),
        ReadMoreText(
          p1.description ?? '--',
          trimLines: 6,
          trimMode: TrimMode.Line,
          trimExpandedText: ' Show less',
          trimCollapsedText: ' Show more',
          moreStyle: styleText(
            fontWeight: FontWeight.bold,
            fontSize: responsiveUI.normalSize,
            color: App.themeColor.secondary,
            shadows: [
              Shadow(
                color: Color.alphaBlend(
                  Colors.black.withOpacity(0.5),
                  App.themeColor.primary,
                ),
                blurRadius: 15,
              )
            ],
          ),
          lessStyle: styleText(
            fontWeight: FontWeight.bold,
            fontSize: responsiveUI.normalSize,
            color: App.themeColor.secondary,
            shadows: [
              Shadow(
                color: Color.alphaBlend(
                  Colors.black.withOpacity(0.5),
                  App.themeColor.primary,
                ),
                blurRadius: 15,
              )
            ],
          ),
          style: styleText(fontSize: responsiveUI.normalSize),
        ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Tags
        SizedBox(height: responsiveUI.own(0.05)),
        ShadowText(
          'Tags',
          fontSize: responsiveUI.own(0.045),
          fontWeight: FontWeight.bold,
        ),
        VnDetailGeneralTags(p2: p2),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Screenshots
        SizedBox(height: responsiveUI.own(0.05)),
        ShadowText(
          'Screenshots',
          fontSize: responsiveUI.own(0.045),
          fontWeight: FontWeight.bold,
        ),
        VnDetailGeneralScreenshots(p2: p2),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
