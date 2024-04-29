import 'package:hive_flutter/adapters.dart';
import 'package:myfinplan/data/models/category/base_category.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transact_plan_detail.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/services/storage/hive/box_names.dart';
import 'package:myfinplan/utils/time/times.dart';

final adapters = <HiveAdapter>[
  HiveAdapter<TransactPlanDetail>(TransactPlanDetailAdapter()),
  HiveAdapter<Transaction>(
    TransactionAdapter(),
    boxName: transactionBoxName,
  ),
  HiveAdapter<TransactionType>(TransactionTypeAdapter()),
  HiveAdapter<Category>(
    CategoryAdapter(),
    boxName: categoryBoxName,
  ),
  HiveAdapter<Budget>(BudgetAdapter()),
  HiveAdapter<TimeRange>(TimeRangeAdapter()),
  HiveAdapter<TimeType>(TimeTypeAdapter()),
  HiveAdapter<CustomIconData>(CustomIconDataAdapter()),
];

class HiveAdapter<T> {
  String boxName;
  TypeAdapter<T> adapter;

  HiveAdapter(this.adapter, {this.boxName = ''});

  Future<void> openBox() async {
    if (boxName.isNotEmpty) {
      await Hive.openBox<T>(boxName);
    }
  }

  void register() {
    Hive.registerAdapter<T>(adapter);
  }
}
