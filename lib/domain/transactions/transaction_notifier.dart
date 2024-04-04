import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo_impl.dart';

final transactionNotifierProvider = ChangeNotifierProvider((ref) {
  return TransactionNotifier(ref.watch(transactionRepoProvider));
});

class TransactionNotifier extends ChangeNotifier {
  final TransactionRepository repo;

  TransactionNotifier(this.repo);

  void addTransaction(Transaction newTransaction) async {
    await repo.add(newTransaction);
    notifyListeners();
  }

  Future<List<Transaction>> getAllTransaction() {
    return repo.getAll();
  }

  Future<List<Transaction>> getTransactionByType(TransactionType type) {
    return repo.getByType(type);
  }

  Future<void> updateTransaction(Transaction updatedItem) async {
    await repo.update(updatedItem);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await repo.delete(id);
    notifyListeners();
  }
}
