import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/plan/debts/debt_tab.dart';
import 'package:myfinplan/screens/plan/plan_transaction/plan_transact_tab.dart';
import 'package:myfinplan/screens/plan/savings/saving_tab.dart';
import 'package:myfinplan/screens/plan/schedule/schedule_tab.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_timerange_picker.dart';
import 'package:myfinplan/screens/plan/summary/plan_summary_tab.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

final planTabBarItems = [
  const Tab(child: Text(planSummaryTabLabel)),
  const Tab(child: Text(planScheduleTabLabel)),
  const Tab(child: Text(planTransactionTabLabel)),
  const Tab(child: Text(planSavingTabLabel)),
  const Tab(child: Text(planDebtTabLabel)),
];

final planTimeRangeProvider = StateProvider((ref) => TimeRange.rangeByType(TimeType.month));

class _PlanScreenState extends State<PlanScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: planTabBarItems.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
          title: planScreenTitle,
          bottom: TabBar(
            controller: tabController,
            tabs: planTabBarItems,
            isScrollable: true,
            labelColor: CupertinoColors.activeBlue,
            unselectedLabelColor: Colors.grey,
          ),
          trailings: [
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final currentTimeRange = ref.watch(planTimeRangeProvider);
                return Row(
                  children: [
                    Text(
                      currentTimeRange.toString(),
                      softWrap: true,
                      style: const TextStyle(color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PlanTimerangePickerDialog(
                              initValue: ref.read(planTimeRangeProvider),
                              onSubmit: (newRange) {
                                ref.read(planTimeRangeProvider.notifier).state = newRange;
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.calendar_today, color: Colors.black),
                    ),
                  ],
                );
              },
            ),
          ]),
      body: TabBarView(
        controller: tabController,
        children: const [
          PlanSummaryTab(),
          ScheduleTab(),
          PlanTransactionTab(),
          SavingTab(),
          DebtManageTab(),
        ],
      ),
    );
  }
}
