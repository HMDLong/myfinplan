import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';

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
