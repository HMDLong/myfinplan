import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/base_category.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/category_group.dart';
import 'package:myfinplan/domain/categories/category_notifier.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/time/times.dart';

final getCategoriesWithBudget = FutureProvider((ref) async {
  final categories = (await ref.watch(categoryNotifierProvider).getCategories()).where((cate) => cate.budget != null);
  return categories;
});

class CategoryQueryDetail {
  String categoryId;
  TimeRange? range;

  CategoryQueryDetail(this.categoryId, {this.range});
}

final getTotalSpentByCategory = FutureProvider.family<int, String>(
  (ref, detail) async {
    final transactions = await ref.watch(transactionNotifierProvider).getAllTransaction();
    if (BaseCategory.isChild(detail)) {
      final res = transactions.where((transact) {
        return transact.paid && transact.categoryId == detail; // && (detail.range?.contain(transact.timestamp) ?? true);
      }).fold(0, (prev, element) {
        return prev + element.amount;
      });
      return res;
    }
    final res = transactions.where((element) => ParentCategory.parentHasChild(detail, element.categoryId)).fold(0, (prev, e) => prev + e.amount);
    return res;
  },
);

// final getTotalSpentByCategory = FutureProvider.family<int, CategoryQueryDetail>(
//   (ref, detail) async {
//     final transactions = await ref.watch(transactionNotifierProvider).getAllTransaction();
//     if (ParentCategory.isChild(detail.categoryId)) {
//       final res = transactions.where((transact) {
//         return transact.paid && transact.categoryId == detail.categoryId; // && (detail.range?.contain(transact.timestamp) ?? true);
//       }).fold(0, (prev, element) {
//         return prev + element.amount;
//       });
//       return res;
//     }
//     final res = transactions.where((element) => ParentCategory.parentHasChild(detail.categoryId, element.categoryId)).fold(0, (prev, e) => prev + e.amount);
//     return res;
//   },
// );

final getTotalBudgetSpent = FutureProvider((ref) async {
  final categoriesWithBudgets = ref.watch(getCategoriesWithBudget).when<List<Category>>(
        data: (data) => data.toList(),
        error: (error, _) => throw Exception("$error"),
        loading: () => [],
      );
  int res = 0;
  for (var category in categoriesWithBudgets) {
    res += ref.watch(getTotalSpentByCategory(category.id)).when<int>(
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
