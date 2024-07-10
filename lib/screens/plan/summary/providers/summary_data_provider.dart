import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
// import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/plan/distributor/distributor.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/constants/predefined_categories.dart';

// class SummaryDataModel with EquatableMixin {
//   int planIncome;
//   int realIncome;

//   @override
//   List<Object?> get props => throw UnimplementedError();
// }

final summaryDataProvider = FutureProvider<List<int>>((ref) async {
  final time = ref.watch(planTimeRangeProvider);
  final transactNotifier = ref.watch(transactionNotifierProvider);
  final transacts = (await transactNotifier.getAllTransaction()).where((e) => time.contain(e.timestamp));
  final schedules = await transactNotifier.getScheduledTransacts(range: time);
  final accsProvider = ref.watch(accountsProvider);
  final dist = ref.watch(planDistProvider);
  // incomes
  final incomes = transacts.where((e) => e.transactType == TransactionType.income);
  // final planIncome = incomes.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final planIncome = schedules.where((e) => e.transactType == TransactionType.income).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final realIncome = incomes.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount.abs());
  // expenses
  final expenses = transacts.where((e) => e.transactType == TransactionType.expense);
  // final planExpenses = expenses.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final planExpenses = schedules.where((e) => e.transactType == TransactionType.expense).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final realExpenses = expenses.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount.abs());
  // savings
  // final savings = (await accsProvider.getAccountByType(AccountType.saving)).cast<Saving>();
  final planSaving = max(planIncome, realIncome) * dist.dist[Level.saving]!;
  final realSaving = transacts.where((e) => e.paid && e.categoryId == SpecialCategory.saving).fold(0, (prev, e) => prev + e.amount);
  // loans
  final debts = (await accsProvider.getAccountByType(AccountType.loan)).cast<Loan>();
  final planDebtPay = debts.fold(0, (prev, e) => prev + e.getMonthlyPayment().toInt().abs()); // TODO
  final realDebtPaid = transacts.where((e) => e.paid && e.categoryId == SpecialCategory.loanPayment).fold(0, (prev, e) => prev + e.amount.abs());
  // growth
  final planInflow = planIncome - planExpenses - planDebtPay.abs();
  final realInflow = realIncome - realExpenses - realDebtPaid.abs();
  return [
    planIncome,
    realIncome,
    planExpenses,
    realExpenses,
    planSaving.toInt(),
    realSaving,
    planDebtPay,
    realDebtPaid,
    planInflow,
    realInflow,
  ];
});
