import 'package:hive/hive.dart';

part 'time_type.g.dart';

@HiveType(typeId: 7)
enum TimeType {
  @HiveField(0)
  day,
  @HiveField(1)
  week,
  @HiveField(2)
  month,
  @HiveField(3)
  year,
  @HiveField(4)
  custom;

  static TimeType fromString(String id) {
    return switch (id) {
      "d" => TimeType.day,
      "w" => TimeType.week,
      "m" => TimeType.month,
      "y" => TimeType.year,
      _ => throw "Unrecognized $id",
    };
  }

  String toChar() {
    return name[0];
  }

  String stringify() {
    if (index == 0) {
      return "ngày";
    }
    if (index == 1) {
      return "tuần";
    }
    if (index == 2) {
      return "tháng";
    }
    if (index == 3) {
      return "năm";
    }
    if (index == 4) {
      return "";
    }
    throw "Unknown index $index";
  }
}
