import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/data/repositories/transaction/transaction_repo.dart';
import 'package:myfinplan/services/storage/hive/box_names.dart';

final transactionRepoProvider = Provider((ref) => TransactionRepositoryImpl());

class TransactionRepositoryImpl extends TransactionRepository {
  final transactionBox = Hive.box<Transaction>(transactionBoxName);

  @override
  Future<void> add(Transaction newItem) {
    return transactionBox.put(newItem.id, newItem);
  }

  @override
  Future<void> addAll(List<Transaction> newItems) {
    return transactionBox.putAll(newItems.asMap().map((key, value) => MapEntry(value.id, value)));
  }

  @override
  Future<void> delete(id) {
    return transactionBox.delete(id);
  }

  @override
  Future<List<Transaction>> getAll() async {
    return transactionBox.values.toList();
  }

  @override
  Future<Transaction?> getById(id) async {
    assert(id is String);
    return transactionBox.values.where((transaction) => transaction.id == id).firstOrNull;
  }

  @override
  Future<List<Transaction>> getByType(TransactionType type) async {
    return transactionBox.values.where((transaction) => transaction.transactType == type).toList();
  }

  @override
  Future<void> update(Transaction updatedItem) {
    return updatedItem.save();
  }
}
