import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/models/plan/plan_transact_detail.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/screens/plan/plan_transaction/components/data_table.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/shared_widgets/menu/menu.dart';
import 'package:myfinplan/utils/strings.dart';

class PlanTransactionTab extends ConsumerStatefulWidget {
  const PlanTransactionTab({super.key});

  @override
  ConsumerState<PlanTransactionTab> createState() => _PlanTransactionTabState();
}

final expenseIncomeDetailProvider = FutureProvider<List<PlanTransactDetail>>(
  (ref) async {
    final selectedTransactType = ref.watch(selectedTransactTypeProvider);
    final timeRange = ref.watch(planTimeRangeProvider);
    final categories = (await ref.watch(categoryNotifierProvider).getCategories()).where((e) => e.type == selectedTransactType);
    final transactions = (await ref.watch(transactionNotifierProvider).getTransactionByType(selectedTransactType)).where((e) => timeRange.contain(e.timestamp));
    final planTramsacts = await ref.watch(transactionNotifierProvider).getScheduledTransacts(range: timeRange);
    log(planTramsacts.toString());
    final res = <PlanTransactDetail>[];
    for (var category in categories) {
      final cateTransacts = transactions.where((e) => e.categoryId == category.id).toList();
      final actualAmount = cateTransacts.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount).abs();
      int planAmount;
      if (category.budget != null) {
        planAmount = category.budget!.amount;
      } else {
        // planAmount = cateTransacts.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount).abs();
        planAmount = planTramsacts.where((e) => e.categoryId == category.id).fold(0, (prev, e) => prev + e.planDetail!.planAmount.abs());
      }
      final data = PlanTransactDetail(plan: planAmount, actual: actualAmount, category: category);
      // check if there are data of category, if not put it at the end so that
      // category with data will appear at the top of the list
      if (planAmount == 0 && actualAmount == 0) {
        res.add(data);
      } else {
        res.insert(0, data);
      }
    }
    return res;
  },
);

final selectedTransactTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.expense);

class _PlanTransactionTabState extends ConsumerState<PlanTransactionTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        children: [
          CustomMenu(
            items: const [
              DropdownMenuEntry(value: TransactionType.expense, label: "Chi phí"),
              DropdownMenuEntry(value: TransactionType.income, label: "Thu nhập"),
            ],
            onChanged: (newType) {
              setState(() {
                ref.read(selectedTransactTypeProvider.notifier).state = newType;
              });
            },
          ),
          const SizedBox(height: 10),
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(expenseIncomeDetailProvider).when(
                    data: (data) {
                      final type = ref.watch(selectedTransactTypeProvider);
                      int planTotal = 0;
                      int actualTotal = 0;
                      for (var detail in data) {
                        planTotal += detail.plan;
                        actualTotal += detail.actual;
                      }
                      return Column(
                        children: [
                          LinearProgressGauge(
                            value: actualTotal,
                            max: planTotal,
                            showOverflow: true,
                            mode: type == TransactionType.expense ? GaugeMode.limit : GaugeMode.goodOverflow,
                            leadingLabel: "Thực tế",
                            trailingLabel: "Dự kiến",
                          ),
                          const SizedBox(height: 10),
                          ExpandableDataTable(data: data, type: type),
                          const SizedBox(height: 50),
                        ],
                      );
                    },
                    error: (error, _) => const SizedBox(
                      child: Text(StringRes.widgetErrorMessage),
                    ),
                    loading: () => const SizedBox(
                      height: 300,
                      child: CircularProgressIndicator(),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
