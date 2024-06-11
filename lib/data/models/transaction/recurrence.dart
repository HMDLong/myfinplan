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
  String get getPlanTransactId;

  Recurrence();

  factory Recurrence.fromPlanTransactId(String id) {
    switch (id[0]) {
      case 'p':
        return PeriodicRecurrence.fromId(id);
      case 'i':
        return IntervalRecurrence.fromId(id);
      default:
        throw Exception("Invalid id to type");
    }
  }

  String stringify();
  List<DateTime> planOccurences(DateTime start, DateTime end);
}

String _pad(int i) {
  return i < 10 ? "0$i" : "$i";
}

class PeriodicRecurrence extends Recurrence {
  TimeType periodicType;
  DateTime example;

  PeriodicRecurrence({
    required this.periodicType,
    required this.example,
  });

  factory PeriodicRecurrence.fromId(String id) {
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
  String get getPlanTransactId {
    return "p${periodicType.toChar()}${_pad(example.day)}${_pad(example.month)}${example.year - 2000}.${getRandomKey()}";
  }

  @override
  String stringify() => switch (periodicType) {
        TimeType.day => "Mỗi ngày",
        TimeType.week => "${example.weekday == 7 ? "CN" : "Thứ ${example.weekday + 1}"} hàng tuần",
        TimeType.month => "${example.day} hàng tháng",
        TimeType.year => "${example.day}/${example.month} hàng năm",
        TimeType.custom => "",
      };

  @override
  List<DateTime> planOccurences(DateTime start, DateTime end) {
    // TODO: implement planOccurences
    throw UnimplementedError();
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

  factory IntervalRecurrence.fromId(String id) {
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
  String get getPlanTransactId {
    final sd = startDate.day < 10 ? "0${startDate.day}" : "${startDate.day}";
    final sm = startDate.month < 10 ? "0${startDate.month}" : "${startDate.month}";
    final sy = "${startDate.year - 2000}";
    final i = interval < 10 ? "0$interval" : "$interval";
    return "i$sd$sm$sy${intervalType.toChar()}$i.${getRandomKey()}";
  }

  @override
  String stringify() {
    return "Mỗi $interval ${intervalType.stringify()}";
  }

  @override
  List<DateTime> planOccurences(DateTime start, DateTime end) {
    // TODO: implement planOccurences
    throw UnimplementedError();
  }
}
