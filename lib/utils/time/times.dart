import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myfinplan/utils/time/time_lib.dart';
import 'package:myfinplan/utils/time/time_type.dart';

part 'times.g.dart';

@HiveType(typeId: 8)
class TimeRange extends Equatable {
  @HiveField(0)
  final TimeType timeType;
  @HiveField(1)
  late final DateTime start;
  @HiveField(2)
  late final DateTime end;

  TimeRange({
    required DateTime start,
    required DateTime end,
    this.timeType = TimeType.day,
  }) {
    this.start = start.toDateOnly();
    this.end = end.toDateOnly();
  }

  factory TimeRange.rangeByType(TimeType type, {DateTime? start, DateTime? end}) => switch (type) {
        TimeType.day => getRangeOfDay(),
        TimeType.week => getRangeOfTheWeek(),
        TimeType.month => getRangeOfTheMonth(),
        TimeType.year => getRangeOfTheYear(),
        TimeType.custom => start != null && end != null ? TimeRange(start: start, end: end, timeType: TimeType.custom) : throw Exception("custom type must have non-nullable [start], [end]")
      };

  /// return a TimeRange of last [n] days from today
  factory TimeRange.lastNDays(int n) {
    return getNDaysBefore(DateTime.now(), n);
  }

  /// create a custom type [TimeRange] that span [n] instance of [TimeType]
  /// E.g: A range of "next 6 months" => [type]=[TimeType.month] and [n]=6
  factory TimeRange.nextNofTimeType(TimeType type, int n, {bool includeCurrent = true}) {
    assert(n > 0);
    var begin = TimeRange.rangeByType(type);
    if (!includeCurrent) {
      begin = begin.next();
    }
    var last = begin;
    for (var i = 1; i <= n; i++) {
      last = last.next();
    }
    return TimeRange(start: begin.start, end: last.end, timeType: TimeType.custom);
  }

  int get duration => end.difference(start).inDays;

  @override
  String toString() {
    switch (timeType) {
      case TimeType.day:
        return "${start.day} Th${start.month} ${start.year}";
      case TimeType.week:
        return "${Formatter.toFullVnDate(start)}  ~  ${Formatter.toFullVnDate(end)}";
      case TimeType.month:
        return Formatter.toVnMonthYear(start);
      case TimeType.year:
        return "${start.year}";
      case TimeType.custom:
        return "${Formatter.toFullVnDate(start)}  ~  ${Formatter.toFullVnDate(end)}";
    }
  }

  /// Check if a [date] is between this range
  bool contain(DateTime date) {
    final dateOnly = date.toDateOnly();
    if (dateOnly.isBefore(start)) return false;
    if (dateOnly.isAfter(end)) return false;
    return true;
  }

  /// Return TimeRange represent the next range relative to [this]
  TimeRange next() {
    return switch (timeType) {
      TimeType.day => getNextDayRange(range: this),
      TimeType.week => getNextWeekRangeByRange(range: this),
      TimeType.month => getNextMonthRangeByRange(range: this),
      TimeType.year => getNextYearRange(range: this),
      TimeType.custom => this,
    };
  }

  /// Return TimeRange represent the previous range relative to [this]
  TimeRange previous() {
    return switch (timeType) {
      TimeType.day => getPreviousDayRange(range: this),
      TimeType.week => getPreviousWeekRangeByRange(range: this),
      TimeType.month => getPreviousMonthRangeByRange(range: this),
      TimeType.year => getPreviousYearRange(range: this),
      TimeType.custom => this,
    };
  }

  /// Return a list contains all the dates that in this range
  List<DateTime> getRangeDates() {
    final rangeDuration = duration;
    return List<DateTime>.generate(rangeDuration + 1, (index) => start.add(Duration(days: index)));
  }

  DateTime randomDay() {
    final rangeDates = getRangeDates();
    return rangeDates[Random().nextInt(rangeDates.length)];
  }

  /// Only work for month type range
  DateTime dayOfMonthRange(int day) {
    return DateTime(start.year, start.month, day);
  }

  /// Return a list of all the [weekday] in this range.
  /// Ex: [weekday] = 6 => all Friday in this range
  List<DateTime> weekdaysOfRange(int weekday) {
    final res = <DateTime>[];
    final dist = weekday - start.weekday;
    var occurence = start.add(Duration(days: dist >= 0 ? dist : dist + 7));
    while (occurence.isBefore(end)) {
      res.add(occurence);
      occurence = occurence.add(const Duration(days: 7));
    }
    return res;
  }

  List<DateTime> monthdaysOfRange(int monthday) {
    final res = <DateTime>[];
    final daysInMonth = getDaysInMonth(start.year, start.month);
    res.add(DateTime(start.year, start.month, min(monthday, daysInMonth)));
    return res;
  }

  /// Currently only usable for type=[TimeType.month, TimeType.week]
  List<DateTime> getOccurences(TimeType type, DateTime example) {
    if (type == TimeType.week) {
      return getRangeDates().where((e) => e.weekday == example.weekday).toList();
    }
    if (type == TimeType.month) {
      return getRangeDates().where((e) => e.day == example.day).toList();
    }
    throw UnimplementedError("Currently only usable for type=[TimeType.month, TimeType.week]");
  }

  @override
  List<Object?> get props => [start, end, timeType];

  @override
  bool? get stringify => true;
}

extension TimeRangeExt on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  DateTime to9PM() {
    return DateTime(year, month, day, 21, 0, 0);
  }

  DateTime to9AM() {
    return DateTime(year, month, day, 9, 0, 0);
  }
}
