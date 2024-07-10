// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomIconDataAdapter extends TypeAdapter<CustomIconData> {
  @override
  final int typeId = 5;

  @override
  CustomIconData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomIconData(
      fields[0] as int,
      fontFamily: fields[1] as String?,
      fontPackage: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomIconData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.codePoint)
      ..writeByte(1)
      ..write(obj.fontFamily)
      ..writeByte(2)
      ..write(obj.fontPackage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CustomIconDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
