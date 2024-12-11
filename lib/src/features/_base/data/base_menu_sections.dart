// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/_base/domain/menu_sections.dart';
import 'package:vndb_lite/src/routing/app_router.dart';

final Map<String, MenuSections> BASE_TAB_MENU_SECTIONS = {
  AppRoute.home.name: const MenuSections(
    title: "Home",
    icon: Icons.home,
  ),
  AppRoute.search.name: const MenuSections(
    title: "Search",
    icon: Icons.search,
  ),
  AppRoute.collection.name: const MenuSections(
    title: "Collection",
    icon: Icons.library_books,
  ),
  AppRoute.others.name: const MenuSections(
    title: "Others",
    icon: Icons.more_horiz,
  ),
};
