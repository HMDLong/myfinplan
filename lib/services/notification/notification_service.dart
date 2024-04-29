import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:myfinplan/data/models/schedule_notification.dart';
import 'dart:developer' as dev;

import 'package:myfinplan/data/models/transaction/recurrence.dart';

List<NotificationChannel> channels = [
  NotificationChannel(
    channelKey: "1",
    channelName: "main",
    channelDescription: null,
    importance: NotificationImportance.High,
  ),
];

class NotificationService extends ChangeNotifier {
  static Future<bool> initialize() {
    return AwesomeNotifications().initialize(null, channels);
  }

  static void askForPermissions() async {
    final isNotiAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isNotiAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static void initListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // receivedAction.actionType;
    // receivedAction.payload?.entries.map((e) => null);
    dev.log("payload: ${receivedAction.payload}");
    dev.log("type: ${receivedAction.actionType}");
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {}

  void scheduleNotification(ScheduledNotification noti, {bool demo = true}) {
    AwesomeNotifications().createNotification(
      schedule: demo
          ? null
          : switch (noti.type) {
              Periodic.daily => NotificationAndroidCrontab.daily(referenceDateTime: noti.referenceDate),
              Periodic.weekly => NotificationAndroidCrontab.weekly(referenceDateTime: noti.referenceDate),
              Periodic.monthly => NotificationAndroidCrontab.monthly(referenceDateTime: noti.referenceDate),
              Periodic.yearly => NotificationAndroidCrontab.yearly(referenceDateTime: noti.referenceDate),
              Periodic.onetime => NotificationAndroidCrontab.fromDate(date: noti.referenceDate),
              Periodic.custom => null
            },
      content: NotificationContent(
        id: noti.notiId,
        channelKey: channels[0].channelKey!,
        notificationLayout: NotificationLayout.BigText,
        title: noti.title,
        body: noti.content,
        payload: noti.payload,
      ),
    );
  }

  void cancelNotification(int notiId) {
    AwesomeNotifications().cancelSchedule(notiId);
  }
}
