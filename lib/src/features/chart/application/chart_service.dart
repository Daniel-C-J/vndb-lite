import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/core/network/network_helper.dart';
import 'package:vndb_lite/src/features/chart/data/local/local_chart_repo.dart';
import 'package:vndb_lite/src/features/chart/data/remote/remote_chart_repo.dart';

part 'chart_service.g.dart';

// This will modify the existing statsChart data map variable that is used by the chart widget directly.
@Riverpod(dependencies: [localChartRepo, remoteChartRepo])
Future<void> getStatsChart(Ref ref) async {
  final localChartRepo = ref.watch(localChartRepoProvider);
  final remoteChartRepo = ref.watch(remoteChartRepoProvider);
  final hasConnection = await ref.watch(networkInfoProvider).isConnected;

  // Downloads and update the latest data.
  if (hasConnection) {
    final fetchedStats = await remoteChartRepo.fetchStats();
    localChartRepo.saveStatsFromMap(fetchedStats.data);
    //
  } else {
    //
    final statsData = localChartRepo.latestStats;

    // This modifies the placeholder data with the already downloaded latest data, if exists.
    if (statsData != null) {
      localChartRepo.modifyStatsFromMap(statsData);
      return;
    }
  }

  // return searchChartStatsData;
}
