import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/schedule_notification.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/personalize/components/gen_data.dart';
import 'package:myfinplan/external/notification/notification_service_provider.dart';
import 'package:myfinplan/utils/styles.dart';

class DemoPanel extends ConsumerWidget {
  const DemoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Demo",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: const AlertDialog(
                            content: SizedBox(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text("Sinh dữ liệu mockup..."),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    genData(ref).then((value) {
                      Navigator.of(context, rootNavigator: true).pop();
                      ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.success("Xong"));
                    });
                  },
                  child: const Text("Generate mock data"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () => schedule(ref),
                  child: const Text("Test schedule"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () => _testNoti(ref),
                  child: const Text("Test noti"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () => cancelAll(ref),
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void schedule(WidgetRef ref) {
    final notiService = ref.read(notificationServiceProvider);
    notiService.scheduleNotifications([
      ScheduledNotification(
        title: "",
        content: "",
        referenceDate: DateTime(2024, 6, 30),
      ),
      ScheduledNotification(
        title: "",
        content: "",
        referenceDate: DateTime(2024, 7, 1),
      ),
    ]);
    log("noti launch");
  }

  void _testNoti(WidgetRef ref) {
    // final notiService = ref.read(notificationServiceProvider);

    // notiService.triggerRandomNotification();
    // ref.read(transactionNotifierProvider).updateSchedule();
  }

  void cancelAll(WidgetRef ref) {
    final notiService = ref.read(notificationServiceProvider);

    notiService.cancelAll();
  }
}
