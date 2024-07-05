import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:myfinplan/data/models/transaction/plan_transaction.dart';
import 'package:myfinplan/data/repositories/base_repo.dart';
import 'package:myfinplan/external/storage/hive/box_names.dart';

final planTransactionRepoProvider = Provider((ref) => PlanTransactionRepoImpl());

abstract class PlanTransactionRepository extends BaseRepository<PlanTransaction> {}

class PlanTransactionRepoImpl extends PlanTransactionRepository {
  final transactionBox = Hive.box<PlanTransaction>(planTransactBoxName);

  @override
  Future<void> add(PlanTransaction newItem) {
    return transactionBox.put(newItem.planId, newItem);
  }

  @override
  Future<void> addAll(List<PlanTransaction> newItems) {
    return transactionBox.putAll(
      {for (var e in newItems) e.planId: e},
    );
  }

  @override
  Future<void> delete(id) {
    return transactionBox.delete(id);
  }

  @override
  Future<List<PlanTransaction>> getAll() async {
    return transactionBox.values.toList();
  }

  @override
  Future<PlanTransaction?> getById(id) async {
    return transactionBox.get(id);
  }

  @override
  Future<void> update(PlanTransaction updatedItem) {
    return transactionBox.put(updatedItem.planId, updatedItem);
  }
}
