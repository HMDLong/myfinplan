import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/repositories/category/category_repo.dart';

final categoryRepoProvider = Provider((_) => CategoryRepositoryImpl());

class CategoryRepositoryImpl extends CategoryRepository {
  final Box<Category> categoryBox = Hive.box<Category>("categories");

  @override
  Future<void> add(Category newItem) async {
    await categoryBox.put(newItem.id, newItem);
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> getAll() async {
    return categoryBox.values.toList();
  }

  @override
  Future<List<Category>> getByType(TransactionType type) async {
    return categoryBox.values.where((cate) => cate.type == type).toList();
  }

  @override
  Future<void> update(Category newValue) {
    return newValue.save();
  }
}
