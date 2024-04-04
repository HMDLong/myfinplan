import 'dart:developer';

import 'package:hive_flutter/adapters.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/services/storage/hive/box_names.dart';

final adapters = <HiveAdapter>[
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
