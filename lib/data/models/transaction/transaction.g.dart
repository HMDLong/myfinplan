// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      categoryId: fields[2] as String,
      categoryName: fields[3] as String,
      srcAccId: fields[5] as String?,
      srcAccName: fields[6] as String?,
      toAccId: fields[7] as String?,
      toAccName: fields[8] as String?,
      description: fields[11] as String?,
      planDetail: fields[9] as TransactPlanDetail?,
    ).._amount = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.categoryName)
      ..writeByte(4)
      ..write(obj._amount)
      ..writeByte(5)
      ..write(obj.srcAccId)
      ..writeByte(6)
      ..write(obj.srcAccName)
      ..writeByte(7)
      ..write(obj.toAccId)
      ..writeByte(8)
      ..write(obj.toAccName)
      ..writeByte(9)
      ..write(obj.planDetail)
      ..writeByte(11)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TransactionAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
