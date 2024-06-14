import 'package:equatable/equatable.dart';
import 'package:myfinplan/utils/time/recurrence.dart';

class ScheduledNotification with EquatableMixin {
  final String planId;
  final String transactId;
  final DateTime referenceDate;
  final String title;
  final String content;

  int get notiId => transactId.hashCode;

  Map<String, String> get payload => {};

  Periodic get type => Periodic.daily; //TODO

  ScheduledNotification({
    required this.title,
    required this.content,
    required this.planId,
    required this.transactId,
    required this.referenceDate,
  });

  @override
  List<Object?> get props => [title, content];

  @override
  bool? get stringify => true;
}
