// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vndb_lite/src/constants/app_info.dart';
import 'package:vndb_lite/src/core/app/navigation.dart';
import 'package:vndb_lite/src/core/network/http_override.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:vndb_lite/src/util/local_notification.dart';

Future<void> initializeApp() async {
  // If in release mode, debugPrint will not print.
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // Global centralized error handlers.
  _initializeErrorHandlers();

  // Necessary to prevent http error for some devices.
  HttpOverrides.global = MyHttpOverrides();

  // Removing the '#' in the URLs on the web.
  usePathUrlStrategy();

  // Getting general app information.
  await AppInfo.init();

  // Initializing local notification.
  await localNotification.init();
  await localNotification.askPermissions();

  // Prevent google font to access internet to download the font again.
  GoogleFonts.config.allowRuntimeFetching = false;
}

void _initializeErrorHandlers() {
  // Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('${details.exception}\n${details.stack}');
  };

  // Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('$error\n$stack');
    return true;
  };

  // TODO better error UI, and use errorLogger.

  // Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return SizedBox(
      height: MediaQuery.sizeOf(NavigationService.currentContext).height,
      width: MediaQuery.sizeOf(NavigationService.currentContext).width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Text(details.toString()),
          ),
        ),
      ),
    );
  };
}
