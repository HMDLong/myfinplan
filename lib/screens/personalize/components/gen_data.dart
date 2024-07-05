import 'dart:math';
import 'dart:developer' as dev;
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
import 'package:myfinplan/data/models/transaction/transact_plan_detail.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

const startBalance = 100000000;

final debits = [
  Debit(id: getRandomKey(), amount: startBalance, title: 'momo'),
  Debit(id: getRandomKey(), amount: startBalance, title: 'mb 201'),
  Debit(id: getRandomKey(), amount: startBalance, title: 'vietinbank 0892'),
];

final cashs = [
  Cash(id: '1', amount: 200000000, title: 'Tiền mặt 2'),
];

final credits = [
  Credit(
    id: getRandomKey(),
    title: "mb credit 223",
    limit: -100000000,
    payment: Infull(
      duedate: DateTime(2023, 4, randomDate(25, 28)),
      minPayment: 0,
      lateInterest: 5.0,
    ),
  ),
  Credit(
    id: getRandomKey(),
    title: "vietinbank credit 983",
    limit: -120000000,
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

int randomDate(int start, int end) => Random().nextInt(end - start) + start;

Cash cash() => cashs[0];
Debit randomDebit() => debits[Random().nextInt(debits.length)];
Credit randomCredit() => credits[Random().nextInt(credits.length)];
Saving randomSaving() => savings[Random().nextInt(savings.length)];
Loan randomLoan() => loans[Random().nextInt(loans.length)];

final payableAccount = <Account>[
  ...cashs,
  ...debits,
  ...credits,
];

Account randomPayable() => payableAccount[Random().nextInt(payableAccount.length)];

final List<Account> accounts = [
  ...cashs,
  ...debits,
  ...credits,
  ...savings,
  ...loans,
];

final now = DateTime.now().toDateOnly();

bool shouldPay(DateTime date, {bool ensureTrue = false}) {
  return now.isBefore(date)
      ? false
      : ensureTrue
          ? true
          : Random().nextBool();
}

Future<void> genData(WidgetRef ref) async {
  // 1. Generate accounts
  final accountNoti = ref.read(accountsProvider.notifier);
  dev.log("--- Adding accounts");
  for (var account in accounts) {
    await accountNoti.addAccount(account);
  }
  dev.log("> Done add accounts");
  final categoryNotifier = ref.read(categoryNotifierProvider.notifier);
  final categoryProvider = ref.read(categoryNotifierProvider);
  final transactController = ref.read(transactionNotifierProvider);
  var range = TimeRange.rangeByType(TimeType.month);
  final monthRanges = <TimeRange>[];
  for (var i = 0; i < 13; i++) {
    monthRanges.insert(0, range);
    range = range.previous();
  }

  // Insert data each month, for total 12 months previously
  for (var monthRange in monthRanges) {
    dev.log("- Generating data for ${monthRange.start.month}/${monthRange.start.year}");
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
    var paid = shouldPay(payday);
    planTransacts.add(
      Transaction(
        id: getRandomKey(),
        timestamp: payday,
        amount: paid ? 5000000 : 0,
        categoryId: "e1.1",
        categoryName: "Tiền thuê",
        srcAccId: paid ? sourceAcc.id : null,
        srcAccName: paid ? sourceAcc.title : null,
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
    paid = shouldPay(payday);
    planTransacts.add(
      Transaction(
        id: getRandomKey(),
        timestamp: payday,
        amount: paid ? 800000 : 0,
        categoryId: "e4.1",
        categoryName: "Điện",
        srcAccId: paid ? sourceAcc.id : null,
        srcAccName: paid ? sourceAcc.title : null,
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
    paid = shouldPay(payday);
    planTransacts.add(
      Transaction(
        id: getRandomKey(),
        timestamp: payday,
        amount: paid ? 800000 : 0,
        categoryId: "e4.2",
        categoryName: "Nước",
        srcAccId: paid ? sourceAcc.id : null,
        srcAccName: paid ? sourceAcc.title : null,
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
    paid = shouldPay(payday);
    planTransacts.add(
      Transaction(
        id: getRandomKey(),
        timestamp: payday,
        amount: paid ? 120000 : 0,
        categoryId: "e4.7",
        categoryName: "Internet",
        srcAccId: paid ? sourceAcc.id : null,
        srcAccName: paid ? sourceAcc.title : null,
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
    paid = shouldPay(payday);
    planTransacts.add(
      Transaction(
        id: getRandomKey(),
        timestamp: payday,
        amount: paid ? 4300000 : 0,
        categoryId: "e5.1",
        categoryName: "Tiền học chính",
        srcAccId: paid ? sourceAcc.id : null,
        srcAccName: paid ? sourceAcc.title : null,
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

    payday = monthRange.dayOfMonthRange(29);
    sourceAcc = randomDebit();
    paid = shouldPay(payday, ensureTrue: true);
    planTransacts.add(
      Transaction(
        id: getRandomKey(),
        timestamp: payday,
        amount: paid ? 20000000 : 0,
        categoryId: "i1.1",
        categoryName: "Lương",
        toAccId: paid ? sourceAcc.id : null,
        toAccName: paid ? sourceAcc.title : null,
        planDetail: TransactPlanDetail(
          id: PeriodicRecurrence(
            periodicType: TimeType.month,
            example: DateTime(2024, 5, 29),
          ).toInfoString,
          planAmount: 20000000,
          planTime: monthRange.dayOfMonthRange(29),
        ),
      ),
    );

    payday = monthRange.dayOfMonthRange(Random().nextInt(1) + 6);
    sourceAcc = randomDebit();
    var toAcc = randomSaving();
    paid = shouldPay(payday);
    planTransacts.add(
      Transaction(
        id: getRandomKey(),
        timestamp: payday,
        amount: paid ? 500000 : 0,
        categoryId: "t1.3",
        categoryName: "Tiết kiệm",
        toAccId: paid ? toAcc.id : null,
        toAccName: paid ? toAcc.title : null,
        srcAccId: paid ? sourceAcc.id : null,
        srcAccName: paid ? sourceAcc.title : null,
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
    dev.log("--- Adding plantransacts");
    final planTransactsCategory = planTransacts.map((e) => e.categoryId).toList();
    for (var transact in planTransacts) {
      await transactController.addTransaction(transact);
    }
    dev.log("> Done adding plan transacts");
    final categories = (await categoryProvider.getCategories()).where((e) => !planTransactsCategory.contains(e.id)).toList();
    for (var date in monthRange.getRangeDates()) {
      if (date.isAfter(now)) continue;
      final transactCount = randomDate(1, 4);
      for (var i = 0; i < transactCount; i++) {
        final cate = categories[randomDate(0, categories.length)];
        final acc = Random().nextBool() ? randomPayable() : cashs[0];
        final toAcc = cate.type == TransactionType.transact ? savings[Random().nextInt(savings.length)] : null;
        final amount = cate.type == TransactionType.expense ? randomDate(5, 20) * 10000 : randomDate(50, 100) * 10000;
        final ts = Transaction(
          id: getRandomKey(),
          timestamp: date,
          amount: amount,
          categoryId: cate.id,
          categoryName: cate.name,
          srcAccId: acc.id,
          srcAccName: acc.title,
          toAccId: toAcc?.id,
          toAccName: toAcc?.title,
        );
        try {
          await transactController.addTransaction(ts);
        } catch (e) {
          var newSrcAcc = randomPayable();
          ts.srcAccId = newSrcAcc.id;
          ts.srcAccName = newSrcAcc.title;
          await transactController.addTransaction(ts);
        }
      }
    }
    dev.log("> Done datagen for ${monthRange.start.month}/${monthRange.start.year}");
  }
  dev.log("Done generating data");
}
