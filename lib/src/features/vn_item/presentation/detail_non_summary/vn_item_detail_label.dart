import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vndb_lite/src/common_widgets/status_label.dart';
import 'package:vndb_lite/src/features/collection/domain/record.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';
import 'package:vndb_lite/src/features/vn/data/local_vn_repo.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/features/vn_item/presentation/detail_non_summary/vn_record_controller.dart';
import 'package:vndb_lite/src/util/format_minutes.dart';

class VnItemDetailLabel extends ConsumerWidget {
  const VnItemDetailLabel({
    super.key,
    required this.p1,
    required this.labelCode,
  });

  final VnDataPhase01 p1;

  final String labelCode;

  Future<String> _getLabelData(WidgetRef ref, String label, {VnRecord? record}) async {
    final labelCode = label.toLowerCase();
    if (labelCode == SortableCode.title.name) return '';
    if (labelCode == SortableCode.rating.name) return (p1.rating! / 10).toStringAsFixed(2);
    if (labelCode == SortableCode.votecount.name) return p1.votecount.toString();
    if (labelCode == SortableCode.released.name) return p1.released!;

    final DateFormat dtFormatter = DateFormat.yMd();

    if (labelCode == SortableCode.length_minutes.name) {
      final localVnRepo = ref.read(localVnRepoProvider);
      final p2 = await localVnRepo.getP2(p1.id);
      return getVnLength(p2!.length_minutes ?? 0);
    }

    if (labelCode == SortableCode.collection.name && record != null) return record.status;

    if (labelCode == SortableCode.vote.name && record != null) return record.vote.toString();

    if (labelCode == SortableCode.added.name && record != null && record.added != 'null') {
      return dtFormatter.format(DateTime.parse(record.added!));
    }

    if (labelCode == SortableCode.started.name && record != null && record.started != 'null') {
      return dtFormatter.format(DateTime.parse(record.started!));
    }

    // TODO create enum?
    if (labelCode == 'orig') return 'Original';
    if (labelCode == 'seq') return 'Sequel';
    if (labelCode == 'preq') return 'Prequel';
    if (labelCode == 'ser') return 'Same Series';
    if (labelCode == 'set') return 'Same Setting';
    if (labelCode == 'char') return 'Characters';
    if (labelCode == 'fan') return 'Fandisc';
    if (labelCode == 'side') return 'Side Story';
    if (labelCode == 'alt') return 'Alternative';

    return toBeginningOfSentenceCase<String>("Unknown");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vnRecord = ref.watch(vnRecordControllerProvider(p1.id));

    if (labelCode != SortableCode.title.name) {
      return FutureBuilder(
        future: _getLabelData(ref, labelCode, record: vnRecord),
        initialData: "",
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return StatusLabel(
            labelCode:
                (labelCode == SortableCode.collection.name && vnRecord != null) ? vnRecord.status : labelCode,
            labelText: snapshot.data,
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
