import 'package:flutter/material.dart';
import 'package:myfinplan/screens/plan/summary/components/plan_picking/plan_strategy_picker.dart';
// import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_notifier_banner.dart';
import 'package:myfinplan/screens/plan/summary/components/summary_chart.dart';
import 'package:myfinplan/screens/plan/summary/components/summary_info_table.dart';

class PlanSummaryTab extends StatefulWidget {
  const PlanSummaryTab({super.key});

  @override
  State<PlanSummaryTab> createState() => _PlanSummaryTabState();
}

class _PlanSummaryTabState extends State<PlanSummaryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        children: const [
          // SizedBox(height: 10),
          // PlanValuateNotifierBanner(),
          SizedBox(height: 10),
          PlanStrategyPicker(),
          SizedBox(height: 10),
          SummaryChart(),
          SizedBox(height: 10),
          SummaryInfoTable(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
