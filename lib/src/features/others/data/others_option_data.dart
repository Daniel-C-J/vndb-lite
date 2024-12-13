// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/others/domain/others_option.dart';
import 'package:vndb_lite/src/routing/app_router.dart';

enum OthersOptionCode {
  bug,
  sync,
  settings,
  about,
}

final Map<String, OthersScreenOption> OTHERS_SCREEN_OPTIONS = {
  OthersOptionCode.bug.name: OthersScreenOption(
    routeName: OthersOptionCode.bug.name,
    leading: Icons.bug_report,
    title: "Report a bug",
    subtitle: "Clicking this will redirect you to github.",
  ),
  OthersOptionCode.sync.name: OthersScreenOption(
    routeName: AppRoute.auth.name,
    leading: Icons.sync,
    title: "Sync account",
    subtitle: "Login/Authenticate your vndb account.",
  ),
  OthersOptionCode.settings.name: OthersScreenOption(
    routeName: AppRoute.settings.name,
    leading: Icons.settings,
    title: "Settings",
  ),
  OthersOptionCode.about.name: OthersScreenOption(
    routeName: AppRoute.about.name,
    leading: Icons.info_outline,
    title: "About",
  ),
};
