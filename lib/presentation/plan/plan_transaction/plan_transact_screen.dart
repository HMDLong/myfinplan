import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/add_plan_transact_screen.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/expense/expense_tab.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/income/income_tab.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PlanTransactScreen extends StatefulWidget {
  final int? initTab;
  const PlanTransactScreen({super.key, this.initTab});

  const PlanTransactScreen.expense({super.key, this.initTab = 1});

  const PlanTransactScreen.income({super.key, this.initTab = 0});

  @override
  State<PlanTransactScreen> createState() => _PlanTransactScreenState();
}

class _PlanTransactScreenState extends State<PlanTransactScreen> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: widget.initTab ?? 0);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Kế hoạch thu chi",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: "Thu nhập"),
            Tab(text: "Chi tiêu & Tiết kiệm"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: tabController,
          children: const [
            IncomeTab(),
            ExpenseTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Boxicons.bx_calendar_plus),
        onPressed: () {
          pushNewScreen(context, screen: const NewPlanTransactScreen());
        },
      ),
    );
  }
}
