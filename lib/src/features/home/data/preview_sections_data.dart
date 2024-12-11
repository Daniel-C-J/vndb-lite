// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/features/home/domain/home_sections_model.dart';
import 'package:vndb_lite/src/features/sort_filter/data/sortable_data.dart';

enum HomeSectionsCode {
  collection,
  rating,
  votecount,
  popularOngoing,
}

// Using name property to retrieve the strings which can be saved in SharedPrefs (LocalDB).
final Map<String, HomePreviewSection> HOME_SCREEN_SECTIONS = {
  HomeSectionsCode.collection.name: HomePreviewSection(
    id: "1",
    title: "My Collection",
    labelCode: SortableCode.collection.name,
    maxPreviewItem: Default.MAX_PREVIEW_ITEMS_CONF,
  ),
  HomeSectionsCode.rating.name: HomePreviewSection(
    id: "2",
    title: "Top by Rating",
    labelCode: SortableCode.rating.name,
    filter: Default.REMOTE_FILTER_CONF,
    maxPreviewItem: Default.MAX_PREVIEW_ITEMS_CONF,
  ),
  HomeSectionsCode.votecount.name: HomePreviewSection(
    id: "3",
    title: "Top by Votes",
    labelCode: SortableCode.votecount.name,
    filter: Default.REMOTE_FILTER_CONF,
    maxPreviewItem: Default.MAX_PREVIEW_ITEMS_CONF,
  ),
  HomeSectionsCode.popularOngoing.name: HomePreviewSection(
    id: "4",
    title: "Popular Ongoing",
    labelCode: SortableCode.votecount.name,
    filter: Default.REMOTE_FILTER_CONF.copyWith(devstatus: [1]),
    maxPreviewItem: Default.MAX_PREVIEW_ITEMS_CONF,
  ),
};
