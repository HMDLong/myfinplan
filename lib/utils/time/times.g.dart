// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'times.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeRangeAdapter extends TypeAdapter<TimeRange> {
  @override
  final int typeId = 8;

  @override
  TimeRange read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeRange(
      start: fields[1] as DateTime,
      end: fields[2] as DateTime,
      timeType: fields[0] as TimeType,
    );
  }

  @override
  void write(BinaryWriter writer, TimeRange obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timeType)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeRangeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
