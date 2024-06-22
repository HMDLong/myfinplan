import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/data/models/transaction/transact_plan_detail.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

class DemoPanel extends ConsumerWidget {
  const DemoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Demo",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: const AlertDialog(
                      content: SizedBox(
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Sinh dữ liệu mockup..."),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
              _genData(ref).then((value) {
                Navigator.of(context, rootNavigator: true).pop();
                ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.success("Xong"));
              });
            },
            child: const Text("Generate mock data"),
          ),
        ],
      ),
    );
  }

  Future<void> _genData(WidgetRef ref) async {
    const startBalance = 10000000000;
    randomDate(int start, int end) => Random().nextInt(end - start) + start;
    // 1. Generate accounts
    // final debitIds = List.generate(3, (index) => getRandomKey());
    // final creditIds = List.generate(2, (index) => getRandomKey());
    // final savingIds = List.generate(3, (index) => getRandomKey());
    final debits = [
      Debit(id: getRandomKey(), amount: startBalance, title: 'momo'),
      Debit(id: getRandomKey(), amount: startBalance, title: 'mb 201'),
      Debit(id: getRandomKey(), amount: startBalance, title: 'vietinbank 0892'),
    ];
    final cashs = [
      Cash(id: '1', amount: startBalance, title: 'Tiền mặt 2'),
    ];
    final credits = [
      Credit(
        id: getRandomKey(),
        title: "mb credit 223",
        limit: 10000000,
        payment: Infull(
          duedate: DateTime(2023, 4, randomDate(25, 28)),
          minPayment: 0,
          lateInterest: 5.0,
        ),
      ),
      Credit(
        id: getRandomKey(),
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
        id: getRandomKey(),
        title: "vp saving 768",
        amount: 10000000,
        goal: Goal(
          title: "mua xe mới",
          targetAmount: 25000000,
          deadline: DateTime(2024, 6, 12),
        ),
      ),
      Saving(
        id: getRandomKey(),
        title: "vp saving 456",
        amount: 10000000,
      ),
    ];
    final loans = [
      Loan(
        id: getRandomKey(),
        title: "vay mua xe",
        amount: 100000000,
        payment: AmortizingFixedTermPayment(
          term: 12,
          interestRate: 0.14,
          monthlyPayDate: DateTime(2020, 5, 30),
        ),
      ),
      Loan(
        id: getRandomKey(),
        title: "vay mua nhà",
        amount: 500000000,
        payment: AmortizingFixedTermPayment(
          term: 36,
          interestRate: 0.06,
          monthlyPayDate: DateTime(2020, 5, 28),
        ),
      ),
    ];

    cash() => cashs[0];
    randomDebit() => debits[Random().nextInt(debits.length)];
    randomCredit() => credits[Random().nextInt(credits.length)];
    randomSaving() => savings[Random().nextInt(savings.length)];
    randomLoan() => loans[Random().nextInt(loans.length)];

    // randomDebitId() => debitIds[Random().nextInt(3)];
    // randomCreditId() => debitIds[Random().nextInt(2)];
    // randomSavingId() => debitIds[Random().nextInt(3)];
    final payableAccount = <Account>[
      ...cashs,
      ...debits,
      ...credits,
    ];
    randomPayable() => payableAccount[Random().nextInt(payableAccount.length)];
    final List<Account> accounts = [
      ...cashs,
      ...debits,
      ...credits,
      ...savings,
      ...loans,
    ];
    randomAccount() => payableAccount[Random().nextInt(payableAccount.length)];

    final now = DateTime.now().toDateOnly();
    bool shouldPay(DateTime date) => now.isAfter(date) ? Random().nextBool() : false;

    final accountNoti = ref.read(accountsProvider.notifier);
    for (var account in accounts) {
      await accountNoti.addAccount(account);
    }
    final categoryNotifier = ref.read(categoryNotifierProvider.notifier);
    final categoryProvider = ref.read(categoryNotifierProvider);
    final transactController = ref.read(transactionNotifierProvider);
    var monthRange = TimeRange.rangeByType(TimeType.month);
    // Insert data each month, for total 12 months previously
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
      final planTransacts = <Transaction>[];
      Account sourceAcc = randomDebit();

      var payday = monthRange.dayOfMonthRange(Random().nextInt(4) + 3);
      planTransacts.add(
        Transaction(
          id: getRandomKey(),
          timestamp: payday,
          amount: shouldPay(payday) ? 0 : 5000000,
          categoryId: "e1.1",
          categoryName: "Tiền thuê",
          srcAccId: sourceAcc.id,
          srcAccName: sourceAcc.title,
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 4),
            ).toInfoString,
            planAmount: 5000000,
            planTime: monthRange.dayOfMonthRange(4),
          ),
        ),
      );

      payday = monthRange.dayOfMonthRange(Random().nextInt(3) + 27);
      sourceAcc = randomPayable();
      planTransacts.add(
        Transaction(
          id: getRandomKey(),
          timestamp: payday,
          amount: shouldPay(payday) ? 0 : 800000,
          categoryId: "e4.1",
          categoryName: "Điện",
          srcAccId: sourceAcc.id,
          srcAccName: sourceAcc.title,
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 28),
            ).toInfoString,
            planAmount: 800000,
            planTime: monthRange.dayOfMonthRange(28),
          ),
        ),
      );

      payday = monthRange.dayOfMonthRange(Random().nextInt(4) + 25);
      sourceAcc = randomPayable();
      planTransacts.add(
        Transaction(
          id: getRandomKey(),
          timestamp: payday,
          amount: shouldPay(payday) ? 0 : 800000,
          categoryId: "e4.2",
          categoryName: "Nước",
          srcAccId: sourceAcc.id,
          srcAccName: sourceAcc.title,
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 27),
            ).toInfoString,
            planAmount: 800000,
            planTime: monthRange.dayOfMonthRange(27),
          ),
        ),
      );

      payday = monthRange.dayOfMonthRange(Random().nextInt(3) + 25);
      sourceAcc = randomPayable();
      planTransacts.add(
        Transaction(
          id: getRandomKey(),
          timestamp: payday,
          amount: shouldPay(payday) ? 0 : 120000,
          categoryId: "e4.7",
          categoryName: "Internet",
          srcAccId: sourceAcc.id,
          srcAccName: sourceAcc.title,
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 26),
            ).toInfoString,
            planAmount: 120000,
            planTime: monthRange.dayOfMonthRange(26),
          ),
        ),
      );

      payday = monthRange.dayOfMonthRange(Random().nextInt(4) + 1);
      sourceAcc = randomPayable();
      planTransacts.add(
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(5),
          amount: shouldPay(monthRange.dayOfMonthRange(5)) ? 0 : 4300000,
          categoryId: "e5.1",
          categoryName: "Tiền học chính",
          srcAccId: randomCredit().id,
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 5),
            ).toInfoString,
            planAmount: 4300000,
            planTime: monthRange.dayOfMonthRange(5),
          ),
        ),
      );
      // payday = monthRange.dayOfMonthRange(Random().nextInt(3) + 1);
      sourceAcc = randomDebit();
      planTransacts.add(
        Transaction(
          id: getRandomKey(),
          timestamp: monthRange.dayOfMonthRange(27),
          amount: 100000000,
          categoryId: "i1.1",
          categoryName: "Lương",
          toAccId: sourceAcc.id,
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 29),
            ).toInfoString,
            planAmount: 100000000,
            planTime: monthRange.dayOfMonthRange(29),
          ),
        ),
      );
      payday = monthRange.dayOfMonthRange(Random().nextInt(1) + 6);
      sourceAcc = randomDebit();
      var toAcc = randomSaving();
      planTransacts.add(
        Transaction(
          id: getRandomKey(),
          timestamp: payday,
          amount: shouldPay(payday) ? 0 : 500000,
          categoryId: "t1.3",
          categoryName: "Tiết kiệm",
          toAccId: toAcc.id,
          toAccName: toAcc.title,
          srcAccId: sourceAcc.id,
          srcAccName: sourceAcc.title,
          planDetail: TransactPlanDetail(
            id: PeriodicRecurrence(
              periodicType: TimeType.month,
              example: DateTime(2024, 5, 28),
            ).toInfoString,
            planAmount: 500000,
            planTime: monthRange.dayOfMonthRange(6),
          ),
        ),
      );

      final planTransactsCategory = planTransacts.map((e) => e.categoryId).toList();
      for (var transact in planTransacts) {
        if (transact.paid) {
          await accountNoti.transfer(
            transact.srcAccId,
            transact.toAccId,
            transact.amount,
          );
        }
        await transactController.addTransaction(transact);
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
            amount: date.isAfter(now) ? 0 : randomDate(2, 10) * 100000,
            categoryId: cate.id,
            categoryName: cate.name,
            srcAccId: acc.id,
            srcAccName: acc.title,
            toAccId: toAcc?.id,
            toAccName: toAcc?.title,
          );
          await transactController.addTransaction(ts);
          await accountNoti.transfer(ts.srcAccId!, ts.toAccId, ts.amount);
        }
      }
      monthRange = monthRange.previous();
    }
    dev.log("Done generating data");
  }
}
