import 'package:intl/intl.dart';

class Formatter {
  static String toVnMonthDate(DateTime time) {
    return "${time.day} Th${time.month}";
  }

  static String toFullVnDate(DateTime time) {
    return "${time.day} Th${time.month} ${time.year}";
  }

  static String toFullVnTimeStamp(DateTime time) {
    return "${time.day} Th${time.month}, ${time.year} ${time.hour}:${time.minute}";
  }

  static String toVnMonthYear(DateTime time) {
    return "Th${time.month} ${time.year}";
  }

  static String amountToDecimal(int amount, {String? currency = "VND"}) {
    return NumberFormat.decimalPattern().format(amount) + (currency == null ? "" : " $currency");
  }

  static String amountToCompact(int amount, {String? currency = "VND"}) {
    return NumberFormat.compact().format(amount) + (currency == null ? "" : " $currency");
  }
}
