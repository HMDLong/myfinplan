import 'package:hive_flutter/adapters.dart';

part 'transaction_type.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income,
  @HiveField(2)
  transact,
}
