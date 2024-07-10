import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/constants/predefined_categories.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/plan/plan_transact_detail.dart';
import 'package:myfinplan/data/models/transaction/transact_plan_detail.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/screens/plan/plan_transaction/add_plan_transact_screen.dart';
import 'package:myfinplan/screens/plan/schedule/widget/schedule_card.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class ScheduleListTab extends ConsumerStatefulWidget {
  const ScheduleListTab({super.key});

  @override
  ConsumerState<ScheduleListTab> createState() => _ScheduleListTabState();
}

final scheduleProvider = FutureProvider((ref) async {
  final time = ref.watch(planTimeRangeProvider);
  final planTransacts = <DateTime, List<Transaction>>{};
  final scheduledTransacts = await ref.watch(transactionNotifierProvider).getScheduledTransacts(range: time);
  for (var transact in scheduledTransacts) {
    final planTime = transact.planDetail!.planTime.toDateOnly();
    planTransacts.putIfAbsent(planTime, () => []);
    planTransacts[planTime]!.add(transact);
  }
  final accounts = await ref.watch(accountsProvider).getAllAccount();
  final loanData = ref.watch(loansInfoProvider).when<LoanInfo?>(
        data: (data) {
          return data;
        },
        error: (error, _) {
          throw Exception(error);
        },
        loading: () => null,
      );
  if (loanData != null) {
    final loanSchedule = loanData.schedule[time.end.toDateOnly()];
    for (var loan in loanData.loans) {
      planTransacts.putIfAbsent(time.end.toDateOnly(), () => []);
      planTransacts[time.end.toDateOnly()]!.add(
        Transaction(
          id: getRandomKey(),
          timestamp: loan.payment.payDate,
          categoryId: SpecialCategory.loanPayment,
          to: loan.id,
          planDetail: TransactPlanDetail(
            planAmount: loanSchedule![loan.id]!.payment.toInt(),
            planTime: loan.payment.payDate,
          ),
        ),
      );
    }
  }
  return planTransacts;
});

class _ScheduleListTabState extends ConsumerState<ScheduleListTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(context, screen: const NewPlanTransactScreen());
        },
        backgroundColor: CupertinoColors.activeBlue,
        child: const Icon(Icons.post_add_rounded),
      ),
      body: ref.watch(scheduleProvider).when(
        data: (data) {
          if (data.isEmpty) {
            return const SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text("Không có lịch trình"),
                ],
              ),
            );
          }
          final keys = data.keys.sorted((a, b) => a.compareTo(b));
          return SingleChildScrollView(
            child: Column(
              children: [
                ...keys.map<Widget>((date) {
                  return Column(
                    children: [
                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(Formatter.toFullVnDate(date)),
                      ),
                      ...data[date]!.map((transact) {
                        return ScheduleCard(schedule: transact);
                      }),
                    ],
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        error: (error, _) {
          return SizedBox.expand(
            child: Center(
              child: Text("$error"),
            ),
          );
        },
        loading: () {
          return const SizedBox.expand(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
