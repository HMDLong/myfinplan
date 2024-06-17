import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/plan/debt_strat.dart';
import 'package:myfinplan/providers/plan/distributor.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

final loansInfoProvider = FutureProvider<LoanInfo>((ref) async {
  final dist = ref.watch(planDistProvider);
  final timeRange = TimeRange.rangeByType(TimeType.month);
  final loans = (await ref.watch(accountsProvider).getAccountByType(AccountType.loan)).cast<Loan>();
  final currentStrategy = ref.watch(currentDebtStratProvider);
  final transacts = (await ref.watch(transactionNotifierProvider).getAllTransaction());
  final planIncome = transacts.where((e) => e.transactType == TransactionType.income && e.planDetail != null && timeRange.contain(e.planDetail!.planTime)).fold(0, (prev, e) => prev + e.amount);
  final actualIncome = transacts.where((e) => e.transactType == TransactionType.income && e.paid && timeRange.contain(e.timestamp!)).fold(0, (prev, e) => prev + e.amount);

  final initialSnowball = max(planIncome, actualIncome) * dist.dist[ExpenseLevel.saving]!;
  final loanPayThisMonth = loans.map((loan) {
    return transacts.where((transact) {
      return transact.paid && transact.toAccId == loan.id && timeRange.contain(transact.timestamp!);
    }).fold<double>(0, (prev, e) => prev + e.amount);
  }).toList();
  final amortizingResult = currentStrategy.scheduleLoans(loans.map((e) => e.clone()).toList(), initialSnowball);
  return LoanInfo(
    schedule: amortizingResult,
    loans: loans,
    paysThisMonth: loanPayThisMonth,
  );
});

final loanSelectedContentProvider = StateProvider<SelectedContentState>((ref) => SelectedContentState.init());

class SelectedContentState with EquatableMixin {
  ContentType content;
  String? loanId;
  DateTime? month;

  SelectedContentState({
    required this.content,
    this.loanId,
    this.month,
  });

  factory SelectedContentState.init() => SelectedContentState(
        content: ContentType.month,
        month: TimeRange.rangeByType(TimeType.month).end,
      );

  SelectedContentState copyWith({
    ContentType? content,
    String? loanId,
    DateTime? month,
  }) {
    return SelectedContentState(
      content: content ?? this.content,
      loanId: loanId ?? this.loanId,
      month: month ?? this.month,
    );
  }

  @override
  List<Object?> get props => [content, loanId, month];
}

enum ContentType {
  loan,
  month,
}
