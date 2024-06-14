import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/plan/plan_transact_detail.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../utils/time/date_time_ext.dart';

class PlanScheduleDataSource extends CalendarDataSource<ScheduleItem> {
  PlanScheduleDataSource(List<ScheduleItem> items) {
    appointments = items;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].scheduleTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].scheduleTime;
  }

  @override
  Color getColor(int index) {
    final transact = appointments![index] as ScheduleItem;
    return transact.color;
  }

  @override
  bool isAllDay(int index) => true;
}

class ScheduleItem {
  final Transaction transact;
  final String transactId;
  final String title;
  final String note;
  final DateTime? transactTime;
  final DateTime scheduleTime;
  final int amount;
  final int actual;

  String get statusText {
    final anchor = transactTime?.toDateOnly() ?? DateTime.now().toDateOnly();
    final diff = scheduleTime.difference(anchor).inDays;
    if (diff < 0) {
      return "Trễ ${diff.abs()} ngày";
    }
    if (actual != 0) {
      return "Sớm $diff ngày";
    }
    return "Sắp tới $diff ngày";
  }

  bool get paid => actual != 0;

  Color get color {
    final isEarly = transactTime?.isBefore(scheduleTime) ?? DateTime.now().toDateOnly().isBefore(scheduleTime);
    final paid = actual != 0;
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
  }

  PlanTransactStatus get status {
    final isEarly = transactTime?.isBefore(scheduleTime) ?? DateTime.now().toDateOnly().isBefore(scheduleTime);
    final paid = actual != 0;
    if (!paid && !isEarly) {
      return PlanTransactStatus.late;
    }
    if (paid && isEarly) {
      return PlanTransactStatus.paid;
    }
    if (paid) {
      return PlanTransactStatus.latePaid;
    }
    return PlanTransactStatus.upcoming;
  }

  ScheduleItem({
    required this.transact,
    required this.transactId,
    required this.title,
    required this.note,
    required this.amount,
    required this.actual,
    this.transactTime,
    required this.scheduleTime,
  });
}
