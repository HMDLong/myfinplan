// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanTransactionAdapter extends TypeAdapter<PlanTransaction> {
  @override
  final int typeId = 100;

  @override
  PlanTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanTransaction(
      planId: fields[0] as String,
      categoryId: fields[1] as String,
      planAmount: fields[2] as int,
      recurInfo: fields[6] as String,
      from: fields[3] as String?,
      to: fields[4] as String?,
      description: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlanTransaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.planId)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.planAmount)
      ..writeByte(3)
      ..write(obj.from)
      ..writeByte(4)
      ..write(obj.to)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.recurInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
