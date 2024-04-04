import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll();
  Future<List<Category>> getByType(TransactionType type);
  Future<void> add(Category newItem);
  Future<void> update(Category newValue);
  Future<void> delete(String id);
}
