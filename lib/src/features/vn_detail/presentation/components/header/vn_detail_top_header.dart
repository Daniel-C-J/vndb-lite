import 'package:flutter/material.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/sort_filter/data/devstatus_data.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn/domain/p2.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/header/vn_detail_top_header_cover.dart';

class VnDetailsTopHeader extends StatelessWidget {
  const VnDetailsTopHeader({
    super.key,
    required this.p1,
    required this.p2,
    required this.animationController,
  });

  final VnDataPhase01 p1;
  final VnDataPhase02 p2;
  final AnimationController animationController;

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  String get _developersName {
    final List<String> result = p2.developers ?? [];

    if (result.isEmpty) return 'Unknown';
    return result.join(" & ");
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VnDetailTopHeaderCover(
          p1: p1,
          p2: p2,
          animationController: animationController,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Title
              Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).width * 0.3),
                child: SingleChildScrollView(
                  child: Text(
                    p1.title,
                    style: TextStyle(
                      fontSize: responsiveUI.own(0.05),
                      fontWeight: FontWeight.bold,
                      color: App.themeColor.tertiary,
                      shadows: [Shadow(color: App.themeColor.secondary, blurRadius: 3)],
                    ),
                  ),
                ),
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Dev names
              SizedBox(height: responsiveUI.own(0.01)),
              ShadowText(_developersName),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Development status indicator
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: responsiveUI.own(0.01)),
                    child: Icon(
                      Icons.circle,
                      size: responsiveUI.own(0.027),
                      color: DEVELOPMENT_STATUS[p2.devstatus]!.color,
                      shadows: const [Shadow(color: Colors.black)],
                    ),
                  ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Dev status

                  ShadowText(
                    DEVELOPMENT_STATUS[p2.devstatus]!.title,
                  ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
