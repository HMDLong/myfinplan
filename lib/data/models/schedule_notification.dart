import 'package:equatable/equatable.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:myfinplan/utils/time/recurrence.dart';

class ScheduledNotification with EquatableMixin {
  final String planId;
  final String transactId;
  final DateTime referenceDate;
  final String title;
  final String content;

  int get notiId => referenceDate.toDateOnly().hashCode;

  Map<String, String> get payload => {};

  Periodic get type => Periodic.daily; //TODO

  ScheduledNotification({
    required this.title,
    required this.content,
    required this.planId,
    required this.transactId,
    required this.referenceDate,
  });

  factory ScheduledNotification.scheduleTransactNoti({
    required DateTime time,
    required String content,
  }) {
    return ScheduledNotification(
      title: "Nhắc lịch thu chi",
      content: content,
      planId: content,
      transactId: "",
      referenceDate: time,
    );
  }

  @override
  List<Object?> get props => [title, content];

  @override
  bool? get stringify => true;
}
