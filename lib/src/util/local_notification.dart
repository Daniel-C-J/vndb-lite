import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vndb_lite/src/constants/app_info.dart';

final localNotification = _LocalNotificationManager();

class _LocalNotificationManager {
  // LocalNotificationManager() {
  //   init();
  // }

  final FlutterLocalNotificationsPlugin instance = FlutterLocalNotificationsPlugin();

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@drawable/sync',
    );

    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: false, // I like silence.
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await instance.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (_) {},
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> askPermissions() async {
    if (Platform.isAndroid) {
      instance
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();

      return;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      await instance
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: false,
          );

      await instance
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: false,
          );
    }
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//

  Future<void> showSyncNotification({int status = 0}) async {
    // TODO create a map/model for this status code?
    // status = -1 -> fail
    // status = 0 -> wait
    // status = 1 -> success

    instance.cancelAll();

    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'basic_channel',
      'sync_channel',
      channelDescription: 'Display cloud synchronization progress.',
      ticker: '${AppInfo.TITLE} Notification',
      showWhen: true,
      colorized: true,
      playSound: false,
      onlyAlertOnce: true,
      color: Colors.transparent,
      priority: Priority.high,
      importance: Importance.max,
      ongoing: (status == 0) ? true : false,
      autoCancel: (status == 0) ? false : true,
      showProgress: (status == 0) ? true : false,
      indeterminate: (status == 0) ? true : false,
      largeIcon: const DrawableResourceAndroidBitmap('@drawable/app_icon'),
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    return await instance.show(
      1,
      (status == 0)
          ? 'Synchronizing VNDB account'
          : (status == 1)
              ? 'Synchronization Completed'
              : 'Synchronization Failed',
      AppInfo.TITLE,
      notificationDetails,
    );
  }

//
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//
}
