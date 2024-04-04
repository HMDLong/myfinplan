enum Periodic {
  yearly,
  monthly,
  weekly,
  daily,
  custom,
}

sealed class Recurrence {
  String get getPlanTransactId;

  void greet() {
    print("recurrence");
  }

  Recurrence();

  factory Recurrence.fromPlanTransactId(String id) {
    switch (id[0]) {
      case 'y':
        return YearlyRecurrence();
      case 'm':
        return MonthlyRecurrence();
      case 'w':
        return WeeklyRecurrence();
      case 'd':
        return DailyRecurrence();
      case 'c':
        return CustomRecurrence();
      default:
        throw Exception("Invalid id to type");
    }
  }
}

class YearlyRecurrence extends Recurrence {
  @override
  String get getPlanTransactId => throw UnimplementedError();
}

class MonthlyRecurrence extends Recurrence {
  @override
  String get getPlanTransactId => throw UnimplementedError();
}

class WeeklyRecurrence extends Recurrence {
  @override
  // TODO: implement getPlanTransactId
  String get getPlanTransactId => throw UnimplementedError();
}

class DailyRecurrence extends Recurrence {
  @override
  // TODO: implement getPlanTransactId
  String get getPlanTransactId => throw UnimplementedError();
}

class CustomRecurrence extends Recurrence {
  @override
  // TODO: implement getPlanTransactId
  String get getPlanTransactId => throw UnimplementedError();
}
