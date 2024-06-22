extension DateTimeExt on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  DateTime to9PM() {
    return DateTime(year, month, day, 21, 0, 0);
  }

  DateTime to9AM() {
    return DateTime(year, month, day, 9, 0, 0);
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
