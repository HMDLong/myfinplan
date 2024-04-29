import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/plan/distributor.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';

final summaryDataProvider = FutureProvider<List<int>>((ref) async {
  final time = ref.watch(planTimeRangeProvider);
  final transacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) => time.contain(e.timestamp));
  final accsProvider = ref.watch(accountsProvider);
  final dist = await ref.watch(planDistNotifierProvider).getCurrentDist();
  // incomes
  final incomes = transacts.where((e) => e.transactType == TransactionType.income);
  final planIncome = incomes.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final realIncome = incomes.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount);
  // expenses
  final expenses = transacts.where((e) => e.transactType == TransactionType.expense);
  final planExpenses = expenses.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final realExpenses = expenses.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount);
  // savings
  // final savings = (await accsProvider.getAccountByType(AccountType.saving)).cast<Saving>();
  final planSaving = max(planIncome, realIncome) * dist.dist[ExpenseLevel.saving]!;
  final realSaving = transacts.where((e) => e.paid && e.categoryId == "t1.3").fold(0, (prev, e) => prev + e.amount);
  // loans
  final debts = (await accsProvider.getAccountByType(AccountType.debt)).cast<Debt>();
  final planDebtPay = debts.fold(0, (prev, e) => prev + e.payment.minimumPayment.abs());
  final realDebtPaid = transacts.where((e) => e.paid && e.categoryId == "t1.2").fold(0, (prev, e) => prev + e.amount);
  return [planIncome, realIncome, planExpenses, realExpenses, planSaving.toInt(), realSaving, planDebtPay, realDebtPaid];
});
