import 'package:equatable/equatable.dart';
import 'package:myfinplan/utils/time/recurrence.dart';

class ScheduledNotification with EquatableMixin {
  final DateTime referenceDate;
  final String title;
  final String content;

  Map<String, String> get payload => {
        "date": referenceDate.toIso8601String(),
      };

  Periodic get type => Periodic.daily; //TODO

  ScheduledNotification({
    required this.title,
    required this.content,
    required this.referenceDate,
  });

  factory ScheduledNotification.scheduleTransactNoti({
    required DateTime time,
  }) {
    return ScheduledNotification(
      title: "Nhắc lịch thu chi",
      content: "",
      referenceDate: time,
    );
  }

  @override
  List<Object?> get props => [title, content];

  @override
  bool? get stringify => true;
}
