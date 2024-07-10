import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/repositories/category/category_repo.dart';
import 'package:myfinplan/data/repositories/category/category_repo_impl.dart';
import 'package:myfinplan/utils/strings.dart';

final categoryNotifierProvider = ChangeNotifierProvider((ref) {
  return CategoryNotifier(ref.watch(categoryRepoProvider));
});

class CategoryNotifier extends ChangeNotifier {
  final CategoryRepository repo;
  CategoryNotifier(this.repo);

  Future<void> addCategory(Category newValue) async {
    await repo.add(newValue);
    notifyListeners();
  }

  Future<List<Category>> getCategories() async {
    return repo.getAll();
  }

  Future<Category?> getCategoryById(String id) async {
    return (await repo.getAll()).where((category) => category.id == id).firstOrNull;
  }

  Future<void> updateCategory(Category newValue) async {
    await repo.update(newValue);
    notifyListeners();
  }

  void deleteCategory(String id) async {
    await repo.delete(id);
    notifyListeners();
  }

  Future<void> addBudget(String categoryId, Budget newBudget) async {
    final category = await getCategoryById(categoryId);
    if (category == null) throw Exception(StringRes.categoryNotFoundMessage);
    category.budget = newBudget;
    await category.save();
    notifyListeners();
  }

  Future<void> deleteBudget(String categoryId) async {
    final category = await getCategoryById(categoryId);
    if (category == null) throw Exception(StringRes.categoryNotFoundMessage);
    category.budget = null;
    await category.save();
    notifyListeners();
  }
}
