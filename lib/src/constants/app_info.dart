// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static late final String TITLE;
  static late final String CURRENT_VERSION;
  static late final String PACKAGE_NAME;
  static late final String BUILD_NUMBER;
  static late final String BUILD_SIGNATURE;
  static const String DESCRIPTION = "A lite, open-source, mobile version of your favorite vndb.org website.";

  static Future<void> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // Making all of these variables accessible synchronously.
    TITLE = packageInfo.appName;
    CURRENT_VERSION = packageInfo.version;
    PACKAGE_NAME = packageInfo.packageName;
    BUILD_NUMBER = packageInfo.buildNumber;
    BUILD_SIGNATURE = packageInfo.buildSignature;
  }
}
