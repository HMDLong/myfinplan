import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/recurrence.dart';
import 'package:myfinplan/data/models/transaction/transact_plan_detail.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/times.dart';

class DemoPanel extends ConsumerWidget {
  const DemoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _genData(ref),
            child: Text("Generate mock data"),
          ),
        ],
      ),
    );
  }

  void _genData(WidgetRef ref) async {
    randomDate(int start, int end) => Random().nextInt(end - start) + start;
    // 1. Generate accounts
    final debitIds = List.generate(3, (index) => getRandomKey());
    final creditIds = List.generate(2, (index) => getRandomKey());
    final savingIds = List.generate(3, (index) => getRandomKey());
    randomDebit() => debitIds[Random().nextInt(3)];
    randomCredit() => debitIds[Random().nextInt(2)];
    randomSaving() => debitIds[Random().nextInt(3)];
    const startBalance = 10000000000;
    final cashs = [
      Cash(id: '1', amount: startBalance, title: 'Tiền mặt 2'),
    ];
    final debits = [
      Debit(id: debitIds[0], amount: startBalance, title: 'momo'),
      Debit(id: debitIds[1], amount: startBalance, title: 'mb 201'),
      Debit(id: debitIds[2], amount: startBalance, title: 'vietinbank 0892'),
    ];
    final credits = [
      Credit(
        id: creditIds[0],
        title: "mb credit 223",
        limit: 10000000,
        payment: Infull(
          duedate: DateTime(2023, 4, randomDate(25, 28)),
          minPayment: 0,
          lateInterest: 5.0,
        ),
      ),
      Credit(
        id: creditIds[1],
        title: "vietinbank credit 983",
        limit: 30000000,
        payment: Infull(
          duedate: DateTime(2023, 4, randomDate(25, 28)),
          minPayment: 0,
          lateInterest: 5.0,
        ),
      ),
    ];
    final savings = [
      Saving(
        id: savingIds[0],
        title: "vp saving 768",
        amount: 10000000,
        goal: Goal(
          title: "mua xe mới",
          targetAmount: 25000000,
          deadline: DateTime(2024, 6, 12),
        ),
      ),
      Saving(
        id: savingIds[1],
        title: "vp saving 456",
        amount: 10000000,
      ),
      Saving(
        id: savingIds[2],
        title: "mb saving 110",
        amount: 0,
        goal: Goal(
          title: "mua pc mới",
          targetAmount: 25000000,
        ),
      ),
    ];
    final List<Account> accounts = [
      ...cashs,
      ...debits,
      ...credits,
      ...savings,
    ];
    final accountNoti = ref.read(accountsProvider.notifier);
    for (var account in accounts) {
      await accountNoti.addAccount(account);
    }
    final categoryNotifier = ref.read(categoryNotifierProvider.notifier);
    final categoryProvider = ref.read(categoryNotifierProvider);
    final transactController = ref.read(transactionNotifierProvider);
    var monthRange = TimeRange.rangeByType(TimeType.month);
    for (var i = 0; i < 13; i++) {
      // 2. Generate some budget
      final budgets = {
        "e2.3": Budget(amount: 1000000, period: monthRange),
        "e6.6": Budget(amount: 2000000, period: monthRange),
        "e7.1": Budget(amount: 1200000, period: monthRange),
        "e7.4": Budget(amount: 1500000, period: monthRange),
      };
      for (var budget in budgets.entries) {
        await categoryNotifier.addBudget(budget.key, budget.value);
      }
      // 3. Generate some plan transactions
      final planTransacts = [
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(26),
          amount: Random().nextBool() ? 0 : 5000000,
          categoryId: "e1.1",
          categoryName: "Tiền thuê",
          accId: randomDebit(),
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 26),
            ).getPlanTransactId,
            planAmount: 5000000,
            planTime: monthRange.dayOfMonthRange(26),
          ),
        ),
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(27),
          amount: Random().nextBool() ? 0 : 800000,
          categoryId: "e4.1",
          categoryName: "Điện",
          accId: randomDebit(),
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 28),
            ).getPlanTransactId,
            planAmount: 800000,
            planTime: monthRange.dayOfMonthRange(28),
          ),
        ),
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(27),
          amount: Random().nextBool() ? 0 : 800000,
          categoryId: "e4.2",
          categoryName: "Nước",
          accId: randomSaving(),
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 27),
            ).getPlanTransactId,
            planAmount: 800000,
            planTime: monthRange.dayOfMonthRange(27),
          ),
        ),
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(25),
          amount: Random().nextBool() ? 0 : 120000,
          categoryId: "e4.7",
          categoryName: "Internet",
          accId: randomCredit(),
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 26),
            ).getPlanTransactId,
            planAmount: 120000,
            planTime: monthRange.dayOfMonthRange(26),
          ),
        ),
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(5),
          amount: Random().nextBool() ? 0 : 4300000,
          categoryId: "e5.1",
          categoryName: "Tiền học chính",
          accId: randomCredit(),
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 5),
            ).getPlanTransactId,
            planAmount: 4300000,
            planTime: monthRange.dayOfMonthRange(5),
          ),
        ),
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(27),
          amount: 100000000,
          categoryId: "i1.1",
          categoryName: "Lương",
          toAccId: randomDebit(),
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 1),
            ).getPlanTransactId,
            planAmount: 100000000,
            planTime: monthRange.dayOfMonthRange(1),
          ),
        ),
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(28),
          amount: Random().nextBool() ? 0 : 500000,
          categoryId: "t1.3",
          categoryName: "Tiết kiệm",
          toAccId: randomSaving(),
          accId: randomDebit(),
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 28),
            ).getPlanTransactId,
            planAmount: 500000,
            planTime: monthRange.dayOfMonthRange(28),
          ),
        ),
      ];
      final planTransactsCategory = planTransacts.map((e) => e.categoryId).toList();
      for (var transact in planTransacts) {
        await transactController.addTransaction(transact);
        if (transact.paid) {
          await accountNoti.transfer(
            transact.accId,
            transact.toAccId,
            transact.amount,
          );
        }
      }
      final categories = (await categoryProvider.getCategories()).where((e) => !planTransactsCategory.contains(e.id)).toList();
      for (var date in monthRange.getRangeDates()) {
        final transactCount = randomDate(1, 5);
        for (var i = 0; i < transactCount; i++) {
          final cate = categories[randomDate(0, categories.length)];
          final acc = Random().nextBool() ? debits[Random().nextInt(debits.length)] : cashs[0];
          final toAcc = cate.type == TransactionType.transact ? savings[Random().nextInt(savings.length)] : null;
          final ts = Transaction(
            id: getRandomKey(),
            timestamp: date,
            amount: randomDate(2, 10) * 100000,
            categoryId: cate.id,
            categoryName: cate.name,
            accId: acc.id,
            accName: acc.title,
            toAccId: toAcc?.id,
            toAccName: toAcc?.title,
          );
          await transactController.addTransaction(ts);
          await accountNoti.transfer(ts.accId!, ts.toAccId, ts.amount);
        }
      }
      monthRange = monthRange.previous();
    }
    dev.log("Done generating data");
  }
}
