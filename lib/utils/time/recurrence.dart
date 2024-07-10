import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

enum Periodic {
  onetime,
  yearly,
  monthly,
  weekly,
  daily,
  custom,
}

sealed class Recurrence {
  String get toInfoString;

  Recurrence();

  factory Recurrence.parse(String id) {
    switch (id[0]) {
      case 'p':
        return PeriodicRecurrence.parse(id);
      case 'i':
        return IntervalRecurrence.parse(id);
      case 'o':
        return OnetimeRecurrence.parse(id);
      default:
        throw Exception("Invalid id to type");
    }
  }

  List<DateTime> planOccurences({TimeRange? range});
}

String _pad(int i) {
  return i < 10 ? "0$i" : "$i";
}

class OnetimeRecurrence extends Recurrence {
  DateTime date;

  OnetimeRecurrence({required this.date});

  factory OnetimeRecurrence.parse(String infoStr) {
    return OnetimeRecurrence(date: DateTime.parse(infoStr.substring(1)));
  }

  @override
  String get toInfoString => "o${date.toIso8601String()}";

  @override
  List<DateTime> planOccurences({TimeRange? range}) {
    return [date];
  }

  @override
  String toString() {
    return Formatter.toFullVnDate(date);
  }
}

class PeriodicRecurrence extends Recurrence {
  TimeType periodicType;
  DateTime example;

  PeriodicRecurrence({
    required this.periodicType,
    required this.example,
  });

  factory PeriodicRecurrence.parse(String id) {
    return PeriodicRecurrence(
      periodicType: TimeType.fromString(id[1]),
      example: DateTime(
        2000 + int.parse(id.substring(6, 8)),
        int.parse(id.substring(4, 6)),
        int.parse(id.substring(2, 4)),
      ),
    );
  }

  @override
  String get toInfoString {
    return "p${periodicType.toChar()}${_pad(example.day)}${_pad(example.month)}${example.year - 2000}.${getRandomKey()}";
  }

  @override
  String toString() => switch (periodicType) {
        TimeType.day => "Mỗi ngày",
        TimeType.week => "${example.weekday == 7 ? "CN" : "Thứ ${example.weekday + 1}"}, hàng tuần",
        TimeType.month => "Ngày ${example.day}, hàng tháng",
        TimeType.year => "${example.day}/${example.month}, hàng năm",
        TimeType.custom => "",
      };

  @override
  List<DateTime> planOccurences({TimeRange? range}) {
    final trange = range ?? TimeRange.nextNofTimeType(TimeType.month, 3);
    switch (periodicType) {
      case TimeType.day:
        return trange.getRangeDates().where((date) => true).toList();
      case TimeType.week:
        return trange.getRangeDates().where((date) => example.weekday == date.weekday).toList();
      case TimeType.month:
        return trange.getRangeDates().where((date) => example.day == date.day).toList();
      case TimeType.year:
        return trange.getRangeDates().where((date) => example.day == date.day && example.month == date.month).toList();
      case TimeType.custom:
        return trange.getRangeDates().where((date) => false).toList();
    }
  }
}

class IntervalRecurrence extends Recurrence {
  int interval;
  TimeType intervalType;
  DateTime startDate;
  DateTime? endDate;

  IntervalRecurrence({
    required this.startDate,
    required this.intervalType,
    required this.interval,
    this.endDate,
  });

  factory IntervalRecurrence.parse(String id) {
    return IntervalRecurrence(
      startDate: DateTime(
        2000 + int.parse(id.substring(5, 7)),
        int.parse(id.substring(3, 5)),
        int.parse(id.substring(1, 3)),
      ),
      intervalType: TimeType.fromString(id[7]),
      interval: int.parse(id.substring(8, 10)),
    );
  }

  @override
  // ID format: {SD}{SM}{SY}{IT}{I}{ED}{EM}{EY}.{RAND}
  // SD = start day
  // SM = start month
  // SY = start year
  // IT = Interval type
  // I = Interval
  String get toInfoString {
    final sd = startDate.day < 10 ? "0${startDate.day}" : "${startDate.day}";
    final sm = startDate.month < 10 ? "0${startDate.month}" : "${startDate.month}";
    final sy = "${startDate.year - 2000}";
    final i = interval < 10 ? "0$interval" : "$interval";
    return "i$sd$sm$sy${intervalType.toChar()}$i.${getRandomKey()}";
  }

  @override
  String toString() {
    return "Mỗi $interval ${intervalType.stringify()}";
  }

  @override
  List<DateTime> planOccurences({TimeRange? range}) {
    final trange = range ?? TimeRange.nextNofTimeType(TimeType.month, 3);
    final duration = switch (intervalType) {
      TimeType.day => Duration(days: interval),
      TimeType.week => Duration(days: interval * 7),
      TimeType.month => Duration(days: interval * 30),
      TimeType.year => Duration(days: interval),
      TimeType.custom => Duration(days: interval),
    };
    final res = <DateTime>[];
    var date = startDate;
    while (!date.isAfter(trange.end)) {
      res.add(date);
      date = date.add(duration);
    }
    return res;
  }
}
