import 'package:flutter/material.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/plan_transact_tab.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanScheduleDataSource extends CalendarDataSource<ScheduleItem> {
  PlanScheduleDataSource(List<ScheduleItem> items) {
    appointments = items;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].timestamp;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].timestamp;
  }

  // @override
  // String getSubject(int index) {
  //   return "${appointments![index].planTransactTitle}";
  // }

  // @override
  // String? getNotes(int index) {
  //   return "${NumberFormat.decimalPattern().format(appointments![index].amount)} VND";
  // }

  @override
  Color getColor(int index) {
    final transact = appointments![index] as ScheduleItem;
    final isEarly = transact.timestamp.isAfter(DateTime.now().toDateOnly());
    final paid = transact.actual == 0;
    if (!paid && !isEarly) {
      return Colors.red;
    }
    if (paid && isEarly) {
      return Colors.green;
    }
    if (paid) {
      return Colors.amber;
    }
    return Colors.blue;

    // return switch((appointments![index] as Transaction).status) {
    //   PaidStatus.late => Colors.red,
    //   PaidStatus.upcoming => Colors.amber,
    //   PaidStatus.paid => Colors.green,
    // };
  }

  @override
  bool isAllDay(int index) => true;
}

class ScheduleItem {
  final String transactId;
  final String title;
  final String note;
  final PlanTransactStatus status;
  final DateTime timestamp;
  final int amount;
  final int actual;

  ScheduleItem({
    required this.transactId,
    required this.title,
    required this.note,
    required this.status,
    required this.amount,
    required this.actual,
    required this.timestamp,
  });
}
