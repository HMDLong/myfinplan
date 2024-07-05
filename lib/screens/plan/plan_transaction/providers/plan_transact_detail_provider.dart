import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/services/plan/distributor.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

final selectedCategoryForDetailProvider = StateProvider<Category?>((ref) => null);

final planTransactsForDetailProvider = FutureProvider((ref) async {
  final planTimeRange = ref.watch(planTimeRangeProvider);
  final cate = ref.watch(selectedCategoryForDetailProvider);
  final transacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) {
    final matchPlanTime = e.planDetail == null ? false : planTimeRange.contain(e.planDetail!.planTime);
    final matchPaidTime = e.paid ? planTimeRange.contain(e.timestamp) : false;
    return e.categoryId == cate!.id && (matchPlanTime || matchPaidTime);
  });
  return transacts;
});

final currentAvailableBudget = FutureProvider((ref) async {
  final currentDist = ref.watch(planDistProvider);
  final currentMonth = TimeRange.rangeByType(TimeType.month);
  final incomeTransacts = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.income)).where((e) => currentMonth.contain(e.timestamp));
  final currentIncome = incomeTransacts.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount);
  final expectedIncome = incomeTransacts.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final maxBudget = max(currentIncome, expectedIncome) * (currentDist.dist[ExpenseLevel.may] ?? 1);
  final currentTotalBudget = (await ref.watch(categoryNotifierProvider).getCategories()).where((e) => e.budget != null).fold(0, (prev, e) => prev + e.budget!.amount);
  final availableBudget = maxBudget - currentTotalBudget;
  return availableBudget;
});
