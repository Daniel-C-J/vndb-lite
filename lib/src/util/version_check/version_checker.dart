import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog.dart';
import 'package:vndb_lite/src/common_widgets/custom_dialog_button.dart';
import 'package:vndb_lite/src/common_widgets/generic_shadowy_text.dart';
import 'package:vndb_lite/src/constants/app_info.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/app/responsive.dart';
import 'package:vndb_lite/src/core/network/dio_factory.dart';

class VersionChecker {
  static final Version currentVersion = Version.parse(AppInfo.CURRENT_VERSION);
  static late final Version latestVersion;

  static const versionSourceUrl =
      "https://raw.githubusercontent.com/Daniel-C-J/vndb-lite/refs/heads/master/VERSION.txt";

  static const updateUrl = "https://github.com/Daniel-C-J/vndb-lite/releases";

  static Future<void> check({required void Function(bool) notify}) async {
    try {
      final response = await _fetchLatestVersion();
      latestVersion = Version.parse(response.data);

      if (needUpdate) {
        _showUpdateFeedbackDialog();
        return;
      }

      // App is up-to-date.
      notify(true);
      return;
      //
    } catch (e) {
      //
      notify(false);
      return;
    }
  }

  // Since this class is only used once, so it would not be using riverpod for singleton purpose, and
  // will directly instance a new temporary DioFactory object.
  static Future<Response> _fetchLatestVersion() async {
    final dio = DioFactory().getDio();
    return await dio.get(versionSourceUrl);
  }

  static bool get needUpdate {
    return currentVersion < latestVersion;
  }

  static void _showUpdateFeedbackDialog() async {
    return await showDialog(
      context: NavigationService.currentContext,
      builder: (context) {
        return CustomDialog(
          useContentPadding: true,
          content: Column(
            children: [
              ShadowText(
                "New Update v$latestVersion",
                align: TextAlign.center,
                fontWeight: FontWeight.bold,
                fontSize: responsiveUI.catgTitle,
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
              SizedBox(height: responsiveUI.own(0.01)),
              ShadowText(
                "There is a new improved version of this app.",
                align: TextAlign.center,
              ),
              SizedBox(height: responsiveUI.own(0.01)),
              ShadowText(
                "Make sure you synchronize all of your current collection to the cloud before updating the app "
                "if you still want to keep your data. Thank you for your attention! :D",
                align: TextAlign.center,
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
              SizedBox(height: responsiveUI.own(0.02)),
              CustomDialogButton(
                text: "Take me to the download page",
                textColor: App.themeColor.primary,
                textShadow: const [
                  Shadow(color: Color.fromARGB(120, 0, 0, 0), blurRadius: 1),
                ],
                color: App.themeColor.tertiary,
                leading: Padding(
                  padding: EdgeInsets.only(right: responsiveUI.own(0.01)),
                  child: Icon(
                    Icons.system_update_alt,
                    color: App.themeColor.primary,
                    size: responsiveUI.own(0.05),
                  ),
                ),
                onPressed: () async {
                  final url = Uri.parse(updateUrl);
                  await launchUrl(url);
                },
              ),
//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
            ],
          ),
        );
      },
    );
  }
}
