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
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/plan_transaction.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

// -------------------------- Accounts ----------------------------------

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

// ----------------------- Scheduled Transactions ----------------------
final rentTmplt = PlanTransaction(
  categoryId: "e1.1",
  planAmount: 5000000,
  recurInfo: PeriodicRecurrence(
    periodicType: TimeType.month,
    example: DateTime(2024, 5, 28),
  ).toInfoString,
);
final powerTmplt = PlanTransaction(
  categoryId: "e4.1",
  planAmount: 800000,
  recurInfo: PeriodicRecurrence(
    periodicType: TimeType.month,
    example: DateTime(2024, 5, 28),
  ).toInfoString,
);
final waterTmplt = PlanTransaction(
  categoryId: "e4.2",
  planAmount: 500000,
  recurInfo: PeriodicRecurrence(
    periodicType: TimeType.month,
    example: DateTime(2024, 5, 27),
  ).toInfoString,
);
final netTmplt = PlanTransaction(
  categoryId: "e4.7",
  planAmount: 800000,
  recurInfo: PeriodicRecurrence(
    periodicType: TimeType.month,
    example: DateTime(2024, 5, 28),
  ).toInfoString,
);
final tuitionTmplt = PlanTransaction(
  categoryId: "e5.1",
  planAmount: 4300000,
  recurInfo: PeriodicRecurrence(
    periodicType: TimeType.month,
    example: DateTime(2024, 5, 5),
  ).toInfoString,
);
final salaryTmplt = PlanTransaction(
  categoryId: "i1.1",
  planAmount: 20000000,
  recurInfo: PeriodicRecurrence(
    periodicType: TimeType.month,
    example: DateTime(2024, 5, 29),
  ).toInfoString,
);

// -------------------- Scheduling -------------------------
final now = DateTime.now().toDateOnly();

bool shouldPay(DateTime date, {bool ensureTrue = false}) {
  return now.isBefore(date)
      ? false
      : ensureTrue
          ? true
          : Random().nextBool();
}

Transaction getScheduledTransact(
  PlanTransaction template,
  DateTime planday,
  DateTime payday,
  int payAmount,
  String? fromId,
  String? toId,
) {
  final transact = template.getTransaction(planday);
  var paid = shouldPay(payday);
  transact.amount = paid ? payAmount : 0;
  transact.from = paid ? fromId : null;
  transact.to = paid ? toId : null;
  transact.timestamp = payday;
  return transact;
}
// --------------------------------- gen function -----------------------------------------

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

  // save schedule templates
  for (var tmpl in [rentTmplt, powerTmplt, waterTmplt, netTmplt, tuitionTmplt, salaryTmplt]) {
    ref.read(transactionNotifierProvider.notifier).addSchedule(tmpl);
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
    final planTransacts = <Transaction>[
      getScheduledTransact(
        rentTmplt,
        monthRange.dayOfMonthRange(4),
        monthRange.dayOfMonthRange(Random().nextInt(4) + 3),
        5000000,
        randomDebit().id,
        null,
      ),
      getScheduledTransact(
        powerTmplt,
        monthRange.dayOfMonthRange(28),
        monthRange.dayOfMonthRange(Random().nextInt(3) + 27),
        800000,
        randomPayable().id,
        null,
      ),
      getScheduledTransact(
        waterTmplt,
        monthRange.dayOfMonthRange(27),
        monthRange.dayOfMonthRange(Random().nextInt(4) + 25),
        500000,
        randomPayable().id,
        null,
      ),
      getScheduledTransact(
        netTmplt,
        monthRange.dayOfMonthRange(26),
        monthRange.dayOfMonthRange(Random().nextInt(3) + 25),
        120000,
        randomPayable().id,
        null,
      ),
      getScheduledTransact(
        tuitionTmplt,
        monthRange.dayOfMonthRange(5),
        monthRange.dayOfMonthRange(Random().nextInt(4) + 1),
        4300000,
        randomPayable().id,
        null,
      ),
      getScheduledTransact(
        salaryTmplt,
        monthRange.dayOfMonthRange(29),
        monthRange.dayOfMonthRange(29),
        20000000,
        null,
        randomDebit().id,
      ),
    ];
    dev.log("> Adding plantransacts");
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
          to: toAcc?.id,
          from: acc.id,
        );
        try {
          await transactController.addTransaction(ts);
        } catch (e) {
          var newSrcAcc = randomPayable();
          ts.from = newSrcAcc.id;
          // ts.srcAccName = newSrcAcc.title;
          await transactController.addTransaction(ts);
        }
      }
    }
    dev.log("> Done datagen for ${monthRange.start.month}/${monthRange.start.year}");
  }
  dev.log("Done generating data");
}
