// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/sort_filter/domain/sortable.dart';

enum SortableCode {
  title,
  added,
  started,
  length_minutes,
  rating,
  released,
  votecount,
  vote,
  searchrank, // searchrank is exclusively for remote search
  collection,
}

final Map<String, Sortable> LOCAL_SORTABLE_DATA = {
  SortableCode.title.name: Sortable(
    title: "Title",
  ),
  SortableCode.added.name: Sortable(
    title: "Time Added",
    icon: Icons.calendar_month,
  ),
  SortableCode.started.name: Sortable(
    title: "Time Started",
    icon: Icons.calendar_month,
  ),
  SortableCode.length_minutes.name: Sortable(
    title: "Length",
    icon: Icons.timelapse,
  ),
  SortableCode.rating.name: Sortable(
    title: "Rating",
    icon: Icons.star,
  ),
  SortableCode.released.name: Sortable(
    title: "Release Date",
    icon: Icons.calendar_month,
  ),
  SortableCode.votecount.name: Sortable(
    title: "Vote Count",
    icon: Icons.electric_bolt,
  ),
  SortableCode.vote.name: Sortable(
    title: "Voted",
    icon: Icons.electric_bolt,
  ),
};

final Map<String, Sortable> REMOTE_SORTABLE_DATA = {
  SortableCode.searchrank.name: Sortable(
    title: "None",
  ),
  SortableCode.title.name: Sortable(
    title: "Title",
  ),
  SortableCode.rating.name: Sortable(
    title: "Rating",
    icon: Icons.star,
  ),
  SortableCode.released.name: Sortable(
    title: "Release Date",
    icon: Icons.calendar_month,
  ),
  SortableCode.votecount.name: Sortable(
    title: "Vote Count",
    icon: Icons.electric_bolt,
  ),
};
