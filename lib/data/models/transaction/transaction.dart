import 'package:hive/hive.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime timestamp;
  @HiveField(2)
  String categoryId;
  @HiveField(3)
  int amount;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? transactAccountId;
  @HiveField(6)
  String? targetAccountId;
  @HiveField(7)
  String? planTransactId;
  @HiveField(8)
  String? planTransactTitle;
  @HiveField(9)
  bool paid;

  TransactionType get transactType => Category.getType(categoryId);

  Transaction({
    required this.id,
    required this.timestamp,
    required this.amount,
    required this.categoryId,
    this.paid = true,
    this.transactAccountId,
    this.targetAccountId,
    this.description,
    this.planTransactId,
    this.planTransactTitle,
  });
}
