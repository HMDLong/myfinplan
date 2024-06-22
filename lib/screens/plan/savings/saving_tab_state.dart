import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/plan/distributor.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';

class SavingTabStateModel {
  List<Saving> savings;
  List<int> savedThisRange;
  int totalNeedToSave;

  SavingTabStateModel({
    required this.savings,
    required this.savedThisRange,
    required this.totalNeedToSave,
  });

  factory SavingTabStateModel.empty() {
    return SavingTabStateModel(
      savings: [],
      savedThisRange: [],
      totalNeedToSave: 0,
    );
  }
}

final incomeProvider = FutureProvider<List<int>>((ref) async {
  final time = ref.watch(planTimeRangeProvider);
  final transacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) => time.contain(e.timestamp));
  final incomes = transacts.where((e) => e.transactType == TransactionType.income);
  final planIncome = incomes.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final realIncome = incomes.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount.abs());
  return [planIncome, realIncome];
});

final needToSaveAmountProvider = Provider<int>((ref) {
  final dist = ref.watch(planDistProvider);
  final needToSaveAmount = ref.watch(incomeProvider).when(
        data: (data) {
          return (max(data[0], data[1]).toDouble() * dist.dist[ExpenseLevel.saving]!).toInt();
        },
        error: (error, _) => throw error,
        loading: () => 0,
      );
  return needToSaveAmount;
});

final savingTabStateProvider = FutureProvider((ref) async {
  final currentTimeRange = ref.watch(planTimeRangeProvider);
  final needToSaveAmount = ref.watch(needToSaveAmountProvider);
  final savings = (await ref.watch(accountsProvider).getAccountByType(AccountType.saving)).cast<Saving>();
  final savingTransact = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.transact)).where((element) {
    return element.paid && currentTimeRange.contain(element.timestamp);
  });
  final res = SavingTabStateModel.empty();
  for (var saving in savings) {
    res.savings.add(saving);
    res.savedThisRange.add(
      savingTransact.where((e) => e.toAccId == saving.id).fold(0, (prev, e) {
        return prev + e.amount.abs();
      }),
    );
  }
  res.totalNeedToSave = needToSaveAmount;
  return res;
});
