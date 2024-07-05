import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/data/models/plan/plan_transact_detail.dart';
import 'package:myfinplan/data/models/plan/saving_info.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/services/plan/distributor.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/distribution_section.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

final selectedTimeRangeProvider = StateProvider((ref) => TimeRange.rangeByType(TimeType.month).previous());
final selectedTransactTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.expense);
final selectedParentCategoryProvider = StateProvider<String?>((ref) => null);

final planTransactDetailProvider = Provider(
  (ref) async {
    final timeRange = ref.watch(selectedTimeRangeProvider);
    final categories = await ref.watch(categoryNotifierProvider).getCategories();
    final transactions = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) => timeRange.contain(e.timestamp ?? e.planDetail!.planTime));

    final res = <PlanTransactDetail>[];
    for (var category in categories) {
      final cateTransacts = transactions.where((e) => e.categoryId == category.id).toList();
      final actualAmount = cateTransacts.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount).abs();
      int planAmount;
      if (category.budget != null) {
        planAmount = category.budget!.amount;
      } else {
        planAmount = cateTransacts.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount).abs();
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

final selectedCategoryDetailProvider = FutureProvider((ref) async {
  final selectedTransactType = ref.watch(selectedTransactTypeProvider);
  final details = (await ref.watch(planTransactDetailProvider)).where((e) => e.category.type == selectedTransactType);
  final selectedParent = ref.watch(selectedParentCategoryProvider);
  if (selectedParent != null) {
    return details.where((e) {
      return e.category.parentId == selectedParent;
    }).map((e) {
      return ChartData(e.category.id, e.category.name, e.plan, e.actual);
    }).toList()
      ..sort((a, b) {
        return b.actual.compareTo(a.actual);
      });
  }
  final res = categoryGroups.values.where((cate) {
    return cate.type == selectedTransactType;
  }).map((e) {
    int plan = 0;
    int actual = 0;
    details.where((detail) => detail.category.parentId == e.id).forEach((detail) {
      plan += detail.plan;
      actual += detail.actual;
    });
    return ChartData(e.id, e.name, plan, actual);
  }).toList()
    ..sort(((a, b) {
      return b.actual.compareTo(a.actual);
    }));
  return res;
});

final goalsDetailProvider = FutureProvider((ref) async {
  final selectedTimeRange = ref.watch(selectedTimeRangeProvider);
  final savings = (await ref.watch(accountsProvider).getAccountByType(AccountType.saving)).cast<Saving>();
  final savingTransacts = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.transact)).where((element) {
    return element.categoryId == "t1.3" && selectedTimeRange.contain(element.timestamp);
  });
  final dist = ref.watch(planDistProvider);
  final totalIncome = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.income)).where((e) => selectedTimeRange.contain(e.timestamp ?? e.planDetail!.planTime));
  final actualIncome = totalIncome.where((element) => element.paid).fold(0, (prev, e) => prev + e.amount);
  final planIncome = totalIncome.where((element) => element.planDetail != null).fold(0, (prev, e) => prev + e.amount);
  final planSaving = max(planIncome, actualIncome) * dist.dist[ExpenseLevel.saving]!;
  return SavingsInfo(
    entries: savings.map((e) {
      return SavingEntry(
        account: e,
        thisMonthActualSaving: savingTransacts.where((transact) {
          return transact.paid && transact.toAccId == e.id;
        }).fold(0, (prev, transact) => prev + transact.amount),
      );
    }).toList(),
    thisMonthPlanSaving: planSaving,
  );
});
