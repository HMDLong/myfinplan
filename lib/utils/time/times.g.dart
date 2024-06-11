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
  bool operator ==(Object other) => identical(this, other) || other is TimeRangeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
