import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/category_group.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/budgets/budget_detail/budget_detail_screen.dart';
import 'package:myfinplan/screens/plan/budgets/new_budget_screen.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BudgetTab extends ConsumerStatefulWidget {
  const BudgetTab({super.key});

  @override
  ConsumerState<BudgetTab> createState() => _BudgetTabState();
}

class BudgetGroupDetail {
  ParentCategory parent;
  List<Category> categories;
  List<int> spentAmount;
  int totalSpent;
  int totalBudget;

  BudgetGroupDetail({
    required this.spentAmount,
    required this.parent,
    required this.categories,
    required this.totalBudget,
    required this.totalSpent,
  });
}

final getCategoriesWithBudgetDetail = FutureProvider((ref) async {
  final categoriesWithBudget = (await ref.watch(categoryNotifierProvider).getCategories()).where((e) => e.budget != null);
  final res = <String, BudgetGroupDetail>{};
  final currentMonth = ref.watch(planTimeRangeProvider);
  final transacts = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.expense)).where((e) {
    return currentMonth.contain(e.timestamp);
  });
  for (var category in categoriesWithBudget) {
    final spentAmount = transacts.where(
      (e) {
        return e.categoryId == category.id && e.paid;
      },
    ).fold(0, (prev, e) {
      return prev + e.amount;
    }).abs();
    if (res.containsKey(category.parentId)) {
      final val = res[category.parentId]!;
      val.categories.add(category);
      val.spentAmount.add(spentAmount);
      val.totalBudget += category.budget!.amount;
      val.totalSpent += spentAmount;
      res[category.parentId] = val;
    } else {
      res[category.parentId] = BudgetGroupDetail(
        parent: categoryGroups[category.parentId]!,
        categories: [category],
        spentAmount: [spentAmount],
        totalBudget: category.budget!.amount,
        totalSpent: spentAmount,
      );
    }
  }
  return res.values.toList();
});

class _BudgetTabState extends ConsumerState<BudgetTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ref.watch(getCategoriesWithBudgetDetail).when(
          data: (data) {
            final budgetTotals = data.fold(<int>[0, 0], (prev, e) {
              prev[0] += e.totalBudget;
              prev[1] += e.totalSpent;
              return prev;
            });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tổng ngân sách"),
                Text(
                  Formatter.amountToDecimal(budgetTotals[0]),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                LinearProgressGauge(
                  value: budgetTotals[1],
                  max: budgetTotals[0],
                  showOverflow: true,
                  mode: GaugeMode.limit,
                  leadingLabel: "Đã chi",
                  trailingLabel: "Còn lại",
                  trailingValue: budgetTotals[0] - budgetTotals[1],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    itemCount: data.length + 1,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        return const SizedBox(
                          height: 40,
                        );
                      }
                      final detail = data[index];
                      return ExpansionTile(
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        initiallyExpanded: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(width: 0.2),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(width: 0.2),
                        ),
                        title: Text(detail.parent.name),
                        leading: Icon(detail.parent.icon.toMaterialIconData()),
                        children: List.generate(detail.categories.length, (index) {
                          final category = detail.categories[index];
                          return GestureDetector(
                            onTap: () {
                              pushNewScreen(context, screen: BudgetDetailScreen(category: category));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(category.name),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: LinearProgressGauge(
                                      value: detail.spentAmount[index],
                                      max: category.budget!.amount,
                                      mode: GaugeMode.limit,
                                      compactLabel: true,
                                      showOverflow: true,
                                      valueFontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          error: (error, _) {
            return SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                  ),
                  const Text("Đã có lỗi xảy ra. Hãy thử lại"),
                ],
              ),
            );
          },
          loading: () {
            return const SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          pushNewScreen(context, screen: const NewBudgetScreen());
        },
      ),
    );
  }
}
