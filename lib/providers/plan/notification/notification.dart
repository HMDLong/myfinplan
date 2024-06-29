import 'package:myfinplan/data/models/notification.dart';

abstract class NotificationService {
  Future<void> init();
  Future<void> schedule(ScheduleNotification noti);
  Future<void> cancel(String id);
}
