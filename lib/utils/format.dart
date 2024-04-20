import 'package:intl/intl.dart';

String toVnMonthDate(DateTime time) {
  return "${time.day} Th${time.month}";
}

String toFullVnDate(DateTime time) {
  return "${time.day} Th${time.month} ${time.year}";
}

String toFullVnTimeStamp(DateTime time) {
  return "${time.day} Th${time.month}, ${time.year} ${time.hour}:${time.minute}";
}

String toVnMonthYear(DateTime time) {
  return "Th${time.month} ${time.year}";
}

String amountToDecimal(int amount, {String? currency = "VND"}) {
  return NumberFormat.decimalPattern().format(amount) + (currency == null ? "" : " $currency");
}

String amountToCompact(int amount, {String? currency = "VND"}) {
  return NumberFormat.compact().format(amount) + (currency == null ? "" : " $currency");
}
