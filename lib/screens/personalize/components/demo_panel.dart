import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:myfinplan/data/models/notification/schedule_notification.dart';
import 'package:myfinplan/external/backup/google_client.dart';
import 'package:myfinplan/external/backup/google_drive_client.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/personalize/components/gen_data.dart';
import 'package:myfinplan/external/notification/notification_service_provider.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:path_provider/path_provider.dart';

class DemoPanel extends ConsumerWidget {
  const DemoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: StyleRes.defaultStyledAppBar(
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
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () => signInGdrive(),
                  child: const Text("Sign in g drive"),
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
    final notiService = ref.read(notificationServiceProvider);
    notiService.triggerRandomNotification();
    // ref.read(transactionNotifierProvider).updateSchedule();
  }

  void cancelAll(WidgetRef ref) {
    final notiService = ref.read(notificationServiceProvider);

    notiService.cancelAll();
  }

  void signInGdrive() async {
    // GDriveClient(
    //   googleSignIn: GoogleSignIn(
    //     scopes: [
    //       'https://www.googleapis.com/auth/drive',
    //     ],
    //   ),
    // ).setDrive();
    try {
      final googleSignIn = GoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/drive',
        ],
      );
      final user = await googleSignIn.signIn();
      if (user != null) {
        log(user.email);
        log(user.authHeaders.toString());
        final client = GoogleHttpClient(await user.authHeaders);
        final driveApi = DriveApi(client);
        final fileToUpload = File(name: "backup_db_finplan");
        // await driveApi.files.create(fileToUpload, uploadMedia: Media(, length));
        log("uploaded");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void checkHive() async {
    final dir = await getApplicationDocumentsDirectory();
    dir.list();
  }
}
