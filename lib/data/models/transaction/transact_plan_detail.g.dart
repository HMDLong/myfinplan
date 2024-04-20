// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transact_plan_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactPlanDetailAdapter extends TypeAdapter<TransactPlanDetail> {
  @override
  final int typeId = 12;

  @override
  TransactPlanDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactPlanDetail(
      planAmount: fields[1] as int,
      planTime: fields[2] as DateTime,
    )..planId = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, TransactPlanDetail obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.planId)
      ..writeByte(1)
      ..write(obj.planAmount)
      ..writeByte(2)
      ..write(obj.planTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactPlanDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
