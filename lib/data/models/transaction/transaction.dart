import 'package:hive/hive.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/data/models/transaction/transact_plan_detail.dart';
import 'package:myfinplan/utils/random.dart';

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
  String categoryName;
  @HiveField(4)
  int _amount;
  @HiveField(5)
  String? srcAccId;
  @HiveField(6)
  String? srcAccName;
  @HiveField(7)
  String? toAccId;
  @HiveField(8)
  String? toAccName;
  @HiveField(9)
  TransactPlanDetail? planDetail;
  @HiveField(11)
  String? description;

  Transaction({
    required this.id,
    required this.timestamp,
    int amount = 0,
    required this.categoryId,
    required this.categoryName,
    this.srcAccId,
    this.srcAccName,
    this.toAccId,
    this.toAccName,
    this.description,
    this.planDetail,
  }) : _amount = amount.abs();

  set amount(int value) => _amount = value.abs();

  int get amount => _amount * (transactType == TransactionType.expense ? -1 : 1);

  TransactionType get transactType => Category.getType(categoryId);

  bool get paid => amount != 0;

  Recurrence? get recurrence => planDetail == null ? null : Recurrence.parse(planDetail!.planId);

  factory Transaction.planTransact({
    required DateTime planTimestamp,
    required String categoryId,
    required String categoryName,
    required int planAmount,
    required String planId,
    String? id,
    String? transactAccId,
    String? transactAccName,
    String? targetAccId,
    String? targetAccName,
  }) {
    return Transaction(
      id: id ?? getRandomKey(),
      amount: 0,
      timestamp: planTimestamp,
      categoryId: categoryId,
      categoryName: categoryName,
      srcAccId: transactAccId,
      srcAccName: transactAccName,
      toAccId: targetAccId,
      toAccName: targetAccName,
      planDetail: TransactPlanDetail(
        id: planId,
        planAmount: planAmount,
        planTime: planTimestamp,
      ),
    );
  }

  Transaction copyWith({
    DateTime? planTime,
  }) {
    return Transaction(
      id: getRandomKey(),
      timestamp: timestamp,
      amount: amount,
      categoryId: categoryId,
      categoryName: categoryName,
      srcAccId: srcAccId,
      srcAccName: srcAccName,
      toAccId: srcAccId,
      toAccName: toAccName,
      planDetail: planDetail?.copyWith(planTime: planTime) ?? planDetail,
    );
  }
}
