import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:myfinplan/data/models/schedule_notification.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'dart:developer' as dev;

// import 'package:myfinplan/utils/time/recurrence.dart';

List<NotificationChannel> channels = [
  NotificationChannel(
    channelKey: "1",
    channelName: "main",
    channelDescription: null,
    importance: NotificationImportance.High,
  ),
];

class NotificationService {
  final bool demo;
  NotificationService({this.demo = true});

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

  /// Entry point when app is launched by user tap a notification
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

  // void scheduleNotification(ScheduledNotification noti, {bool demo = true}) {
  //   AwesomeNotifications().createNotification(
  //     schedule: demo
  //         ? NotificationInterval(interval: 120)
  //         : switch (noti.type) {
  //             Periodic.daily => NotificationAndroidCrontab.daily(referenceDateTime: noti.referenceDate),
  //             Periodic.weekly => NotificationAndroidCrontab.weekly(referenceDateTime: noti.referenceDate),
  //             Periodic.monthly => NotificationAndroidCrontab.monthly(referenceDateTime: noti.referenceDate),
  //             Periodic.yearly => NotificationAndroidCrontab.yearly(referenceDateTime: noti.referenceDate),
  //             Periodic.onetime => NotificationAndroidCrontab.fromDate(date: noti.referenceDate),
  //             Periodic.custom => null,
  //           },
  //     content: NotificationContent(
  //       id: 1,
  //       channelKey: channels[0].channelKey!,
  //       notificationLayout: NotificationLayout.BigText,
  //       title: noti.title,
  //       body: noti.content,
  //       payload: noti.payload,
  //     ),
  //   );
  // }

  // Schedule a list of notifications at the designated date
  Future<void> scheduleNotifications(List<ScheduledNotification> notis) async {
    final notiEngine = AwesomeNotifications();
    final activeNotifis = await notiEngine.listScheduledNotifications();
    for (var noti in notis) {
      try {
        // find the matching scheduled notification at date
        final matchNoti = activeNotifis.firstWhere((notifi) => notifi.content!.id == noti.referenceDate.toIso8601String().hashCode);
        // if there is previously scheduled noti, update then override with new noti
        final scheduleNum = int.parse(matchNoti.content!.payload!["schedule_num"]!);
        notiEngine.createNotification(
          content: NotificationContent(
            id: matchNoti.content!.id!,
            channelKey: channels[0].channelKey!,
            title: matchNoti.content!.title,
            body: "Bạn có ${scheduleNum + 1} khoản thu chi cần thực hiện trong hôm nay",
            payload: {
              "schedule_num": "${scheduleNum + 1}",
            },
          ),
        );
      } on StateError {
        // if not, create new noti
        notiEngine.createNotification(
          schedule: NotificationCalendar.fromDate(date: noti.referenceDate.to9AM(), allowWhileIdle: true),
          content: NotificationContent(
            id: noti.referenceDate.toIso8601String().hashCode,
            channelKey: channels[0].channelKey!,
            title: "Nhắc nhở thu chi (${Formatter.toMonthDate(noti.referenceDate)})",
            body: "Bạn có 1 khoản thu chi cần thực hiện trong hôm nay",
            payload: {
              "schedule_num": "1",
            },
          ),
        );
      }
    }
  }

  /// Immediately trigger an active notification. For debug and demo purpose only
  void triggerRandomNotification() async {
    final notiController = AwesomeNotifications();
    final notifys = await notiController.listScheduledNotifications();
    final contentToTrigger = notifys[Random().nextInt(notifys.length)].content!;
    notiController.createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: contentToTrigger.channelKey!,
        title: contentToTrigger.title,
        body: contentToTrigger.body,
      ),
    );
  }

  // cancel a notification
  void cancelNotification(int notiId) {
    AwesomeNotifications().cancelSchedule(notiId);
  }

  // cancel all notifications
  void cancelAll() {
    AwesomeNotifications().cancelAll();
  }
}
