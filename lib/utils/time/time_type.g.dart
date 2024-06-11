part of "time_type.dart";

class TimeTypeAdapter extends TypeAdapter<TimeType> {
  @override
  final int typeId = 7;

  @override
  TimeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimeType.day;
      case 1:
        return TimeType.week;
      case 2:
        return TimeType.month;
      case 3:
        return TimeType.year;
      case 4:
        return TimeType.custom;
      default:
        return TimeType.day;
    }
  }

  @override
  void write(BinaryWriter writer, TimeType obj) {
    switch (obj) {
      case TimeType.day:
        writer.writeByte(0);
        break;
      case TimeType.week:
        writer.writeByte(1);
        break;
      case TimeType.month:
        writer.writeByte(2);
        break;
      case TimeType.year:
        writer.writeByte(3);
        break;
      case TimeType.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimeTypeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
