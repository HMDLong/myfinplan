import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category_group.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/domain/categories/category_notifier.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';

final chartFilterStateProvider = StateProvider((ref) => CategoryChartFilterState());

class CategoryChartFilterState {
  final String? categoryId;
  final TransactionType type;

  CategoryChartFilterState({
    this.categoryId,
    this.type = TransactionType.expense,
  });

  CategoryChartFilterState copyWith({
    String? categoryId,
    TransactionType? type,
  }) {
    return CategoryChartFilterState(
      categoryId: categoryId,
      type: type ?? this.type,
    );
  }
}

final categoryChartDataProvider = FutureProvider<CategoryChartDataModel>((ref) async {
  final categoryProvider = ref.watch(categoryNotifierProvider);
  final filter = ref.watch(chartFilterStateProvider);
  final transactionProvider = ref.watch(transactionNotifierProvider);

  final displayChildren = filter.categoryId != null;
  final transacts = (await transactionProvider.getTransactionByType(filter.type)).where((e) {
    return e.paid && (displayChildren ? ParentCategory.parentHasChild(filter.categoryId!, e.categoryId) : true);
  });
  final res = CategoryChartDataModel();
  // if there are no data to process, return
  if (transacts.isEmpty) {
    return res;
  }
  // calculate total amount spent by each category
  final transactByCategory = <String, int>{};
  if (displayChildren) {
    for (var transact in transacts) {
      transactByCategory[transact.categoryId] = (transactByCategory[transact.categoryId] ?? 0) + transact.amount;
    }
    for (var entry in transactByCategory.entries) {
      final category = await categoryProvider.getCategoryById(entry.key);
      if (category != null) {
        res.data.add(CategoryChartData(category.name, entry.value, entry.key));
      }
    }
  } else {
    for (var transact in transacts) {
      final parentId = ParentCategory.parentIdFromChild(transact.categoryId);
      transactByCategory[parentId] = (transactByCategory[parentId] ?? 0) + transact.amount;
    }
    for (var entry in transactByCategory.entries) {
      final category = categoryGroups[entry.key];
      if (category != null) {
        res.data.add(CategoryChartData(category.name, entry.value, entry.key));
      }
    }
  }
  return res;
});

class CategoryChartDataModel {
  final List<CategoryChartData> data;

  CategoryChartDataModel({List<CategoryChartData>? chartData}) : data = chartData ?? [];
}

class CategoryChartData {
  CategoryChartData(this.x, this.y, this.categoryId);
  final String x;
  final num y;
  final String categoryId;
}
