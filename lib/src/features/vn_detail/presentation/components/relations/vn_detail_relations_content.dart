import 'package:flutter/material.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/features/vn/domain/p3.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/relations/vn_detail_relations_extlinks.dart';
import 'package:vndb_lite/src/features/vn_detail/presentation/components/relations/vn_detail_relations_relation.dart';

class VnDetailsContentRelations extends StatelessWidget {
  const VnDetailsContentRelations({super.key, required this.p3});

  final VnDataPhase03 p3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// External links
        VnDetailRelationsExtlinks(p3: p3),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Related Vns
        SizedBox(height: responsiveUI.own(0.05)),
        VnDetailRelationsRelation(p3: p3),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
      ],
    );
  }
}
