import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/screens/plan/plan_transaction/add_plan_transact_screen.dart';
import 'package:myfinplan/screens/plan/schedule/widget/schedule_card.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/time/date_time_ext.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class ScheduleListTab extends ConsumerStatefulWidget {
  const ScheduleListTab({super.key});

  @override
  ConsumerState<ScheduleListTab> createState() => _ScheduleListTabState();
}

final scheduleProvider = FutureProvider((ref) async {
  final time = ref.watch(planTimeRangeProvider);
  final planTransacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((transact) {
    return transact.planDetail != null && time.contain(transact.planDetail!.planTime);
  }).fold(<DateTime, List<Transaction>>{}, (previousValue, transact) {
    final planTime = transact.planDetail!.planTime.toDateOnly();
    previousValue.putIfAbsent(planTime, () => []);
    previousValue[planTime]!.add(transact);
    return previousValue;
  });
  return planTransacts;
  // final accounts = await ref.watch(accountsProvider).getAllAccount();
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
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
