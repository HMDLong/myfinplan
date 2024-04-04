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
      amount: fields[3] as int,
      categoryId: fields[2] as String,
      paid: fields[9] as bool,
      transactAccountId: fields[5] as String?,
      targetAccountId: fields[6] as String?,
      description: fields[4] as String?,
      planTransactId: fields[7] as String?,
      planTransactTitle: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.transactAccountId)
      ..writeByte(6)
      ..write(obj.targetAccountId)
      ..writeByte(7)
      ..write(obj.planTransactId)
      ..writeByte(8)
      ..write(obj.planTransactTitle)
      ..writeByte(9)
      ..write(obj.paid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
