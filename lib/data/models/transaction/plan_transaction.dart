import 'package:hive/hive.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transact_plan_detail.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:myfinplan/utils/time/recurrence.dart';

part 'plan_transaction.g.dart';

@HiveType(typeId: 100)
class PlanTransaction with HiveObjectMixin {
  @HiveField(0)
  String planId;
  @HiveField(1)
  String categoryId;
  @HiveField(2)
  int planAmount;
  @HiveField(3)
  String? from;
  @HiveField(4)
  String? to;
  @HiveField(5)
  String? description;
  @HiveField(6)
  String recurInfo;

  PlanTransaction({
    String? planId,
    required this.categoryId,
    required this.planAmount,
    required this.recurInfo,
    this.from,
    this.to,
    this.description,
  }) : planId = planId ?? getRandomKey();

  Recurrence get recur => Recurrence.parse(recurInfo);

  TransactionType get transactType => Category.getType(categoryId);

  String getTransactId(DateTime date) {
    return "$planId.${date.toDateOnly().toString().hashCode}";
  }

  Transaction getTransaction(DateTime date) {
    return Transaction(
      id: getTransactId(date),
      timestamp: date,
      categoryId: categoryId,
      from: from,
      to: to,
      amount: 0,
      planDetail: TransactPlanDetail(
        id: planId,
        planAmount: planAmount,
        planTime: date,
      ),
    );
  }
}
