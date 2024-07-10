import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/base/base_category.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/models/category/category_group/category_group.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/time/times.dart';

final getCategoriesWithBudget = FutureProvider((ref) async {
  final categories = (await ref.watch(categoryNotifierProvider).getCategories()).where((cate) => cate.budget != null);
  return categories;
});

class CategoryQueryDetail with EquatableMixin {
  String categoryId;
  TimeRange? range;

  CategoryQueryDetail(this.categoryId, {this.range});

  @override
  List<Object?> get props => [categoryId, range];
}

final getTotalSpentByCategory = FutureProvider.family<int, CategoryQueryDetail>(
  (ref, detail) async {
    final transactions = await ref.watch(transactionNotifierProvider).getAllTransaction();
    if (BaseCategory.isChild(detail.categoryId)) {
      final res = transactions.where((transact) {
        return transact.paid && transact.categoryId == detail.categoryId && (detail.range?.contain(transact.timestamp) ?? true);
      }).fold(0, (prev, element) {
        return prev + element.amount;
      });
      return res;
    }
    final res = transactions.where((element) {
      return ParentCategory.parentHasChild(detail.categoryId, element.categoryId);
    }).fold(0, (prev, e) {
      return prev + e.amount;
    });
    return res;
  },
);

final getTotalBudgetSpent = FutureProvider((ref) async {
  final categoriesWithBudgets = ref.watch(getCategoriesWithBudget).when<List<Category>>(
        data: (data) => data.toList(),
        error: (error, _) => throw Exception("$error"),
        loading: () => [],
      );
  int res = 0;
  for (var category in categoriesWithBudgets) {
    res += ref.watch(getTotalSpentByCategory(CategoryQueryDetail(category.id))).when<int>(
          data: (data) => data,
          error: (error, _) => throw Exception("$error"),
          loading: () => 0,
        );
  }
  return res.abs();
});

final getTotalBudgetAmount = FutureProvider((ref) async {
  final categories = (await ref.watch(categoryNotifierProvider).getCategories()).where((cate) => cate.budget != null);
  final res = categories.fold(0, (prev, e) => prev + e.budget!.amount);
  return res;
});
