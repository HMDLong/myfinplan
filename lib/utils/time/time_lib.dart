// ------------------ Custom range ----------------------
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

import 'date_time_ext.dart';

TimeRange getNDaysBefore(DateTime date, int n) {
  final dateOnly = date.toDateOnly();
  return TimeRange(
    timeType: TimeType.custom,
    start: dateOnly.subtract(Duration(days: n)),
    end: dateOnly,
  );
}

List<DateTime> getDayOfEveryWeekInMonth(DateTime anchor, int dayInWeek) {
  final monthRange = getRangeOfTheMonth(date: anchor);
  final res = <DateTime>[];
  var lastDayInWeek = monthRange.end;
  while (lastDayInWeek.weekday != dayInWeek) {
    lastDayInWeek = lastDayInWeek.subtract(const Duration(days: 1));
  }
  do {
    res.add(lastDayInWeek);
    lastDayInWeek = lastDayInWeek.subtract(const Duration(days: 7));
  } while (monthRange.contain(lastDayInWeek));
  return res;
}

//------------------- Day as range -----------------------
TimeRange getRangeOfDay({DateTime? date}) {
  final theDay = date ?? DateTime.now();
  return TimeRange(
    timeType: TimeType.day,
    start: theDay.toDateOnly(),
    end: theDay.toDateOnly(),
  );
}

TimeRange getNextDayRange({required TimeRange range}) {
  return TimeRange(
    timeType: TimeType.day,
    start: range.start.add(const Duration(days: 1)),
    end: range.start.add(const Duration(days: 1)),
  );
}

TimeRange getPreviousDayRange({required TimeRange range}) {
  return TimeRange(
    timeType: TimeType.day,
    start: range.start.subtract(const Duration(days: 1)),
    end: range.start.subtract(const Duration(days: 1)),
  );
}

//------------------- Week as range ----------------------
TimeRange getRangeOfTheWeek({DateTime? targetDate}) {
  final anchor = targetDate ?? DateTime.now();
  final monday = DateTime.now().subtract(Duration(days: anchor.weekday - DateTime.monday));
  final sunday = monday.add(const Duration(days: 6));
  return TimeRange(timeType: TimeType.week, start: monday, end: sunday);
}

TimeRange getPreviousWeekRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheWeek(targetDate: date);
  return getPreviousWeekRangeByRange(range: targetRange);
}

TimeRange getPreviousWeekRangeByRange({required TimeRange range}) {
  return TimeRange(
    timeType: TimeType.week,
    start: range.start.subtract(const Duration(days: 7)),
    end: range.end.subtract(const Duration(days: 7)),
  );
}

TimeRange getNextWeekRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheWeek(targetDate: date);
  return getNextWeekRangeByRange(range: targetRange);
}

TimeRange getNextWeekRangeByRange({required TimeRange range}) {
  return TimeRange(
    timeType: TimeType.week,
    start: range.start.add(const Duration(days: 7)),
    end: range.end.add(const Duration(days: 7)),
  );
}

//----------------------- Month as range ------------------------------
int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    return isLeapYear ? 29 : 28;
  }
  const List<int> daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return daysInMonth[month - 1];
}

TimeRange getRangeOfTheMonth({DateTime? date}) {
  final date_ = date ?? DateTime.now();
  return TimeRange(
    timeType: TimeType.month,
    start: DateTime(date_.year, date_.month, 1),
    end: DateTime(date_.year, date_.month, getDaysInMonth(date_.year, date_.month)),
  );
}

TimeRange getPreviousMonthRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheMonth(date: date);
  return getPreviousWeekRangeByRange(range: targetRange);
}

TimeRange getPreviousMonthRangeByRange({required TimeRange range}) {
  final start = range.start;
  if (start.month == 1) {
    return TimeRange(
      timeType: TimeType.month,
      start: DateTime(start.year - 1, 12, 1),
      end: DateTime(start.year - 1, 12, 31),
    );
  }
  return TimeRange(
    timeType: TimeType.month,
    start: DateTime(start.year, start.month - 1, 1),
    end: DateTime(start.year, start.month - 1, getDaysInMonth(start.year, start.month - 1)),
  );
}

TimeRange getNextMonthRangeByDate({required DateTime date}) {
  final targetRange = getRangeOfTheMonth(date: date);
  return getNextMonthRangeByRange(range: targetRange);
}

TimeRange getNextMonthRangeByRange({required TimeRange range}) {
  final start = range.start;
  if (start.month == 12) {
    return TimeRange(
      timeType: TimeType.month,
      start: DateTime(start.year + 1, 1, 1),
      end: DateTime(start.year + 1, 1, 31),
    );
  }
  return TimeRange(
    timeType: TimeType.month,
    start: DateTime(start.year, start.month + 1, 1),
    end: DateTime(start.year, start.month + 1, getDaysInMonth(start.year, start.month + 1)),
  );
}

//--------------- Year as range -----------------
TimeRange getRangeOfTheYear({DateTime? date}) {
  final date_ = date ?? DateTime.now();
  return TimeRange(
    timeType: TimeType.year,
    start: DateTime(date_.year, 1, 1),
    end: DateTime(date_.year, 12, 31),
  );
}

TimeRange getNextYearRange({required TimeRange range}) {
  final start = range.start;
  return TimeRange(
    timeType: TimeType.year,
    start: DateTime(start.year + 1, 1, 1),
    end: DateTime(start.year + 1, 12, 31),
  );
}

TimeRange getPreviousYearRange({required TimeRange range}) {
  final start = range.start;
  return TimeRange(
    timeType: TimeType.year,
    start: DateTime(start.year - 1, 1, 1),
    end: DateTime(start.year - 1, 12, 31),
  );
}
