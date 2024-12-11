import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/chart/domain/chart_stats.dart';

enum StatsCode {
  chars,
  producers,
  releases,
  staff,
  tags,
  traits,
  vn,
}

// The data numbers are only placeholder data which will be updated later on.
final Map<String, ChartStats> searchChartStatsData = {
  StatsCode.chars.name: ChartStats(
    title: "Characters",
    data: 136713,
    color: const Color.fromARGB(120, 20, 255, 0),
    titlePosition: 1.2,
  ),
  StatsCode.producers.name: ChartStats(
    title: "Producers",
    data: 21681,
    color: const Color.fromARGB(120, 0, 230, 255),
    titlePosition: 1.2,
  ),
  StatsCode.releases.name: ChartStats(
    title: "Releases",
    data: 119899,
    color: const Color.fromARGB(120, 255, 240, 0),
    titlePosition: 1.2,
  ),
  StatsCode.staff.name: ChartStats(
    title: "Staffs",
    data: 37896,
    color: const Color.fromARGB(120, 255, 0, 200),
    titlePosition: 1.2,
  ),
  StatsCode.tags.name: ChartStats(
    title: "Tags",
    data: 37896,
    color: const Color.fromARGB(120, 140, 0, 255),
    titlePosition: 0.7,
  ),
  StatsCode.traits.name: ChartStats(
    title: "Traits",
    data: 3244,
    color: const Color.fromARGB(120, 255, 120, 0),
    titlePosition: 1.75,
  ),
  StatsCode.vn.name: ChartStats(
    title: "VNs",
    data: 50368,
    color: const Color.fromARGB(120, 255, 255, 255),
    titlePosition: 1.2,
  ),
};
