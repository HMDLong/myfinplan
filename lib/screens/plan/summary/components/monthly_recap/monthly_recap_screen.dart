import 'package:flutter/material.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/balance_growth_section.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/loans_section.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/distribution_section.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/goals_section.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/in_out_section.dart';
import 'package:myfinplan/utils/styles.dart';

class PlanUpdateScreen extends StatefulWidget {
  const PlanUpdateScreen({super.key});

  @override
  State<PlanUpdateScreen> createState() => _PlanUpdateScreenState();
}

class _PlanUpdateScreenState extends State<PlanUpdateScreen> with AutomaticKeepAliveClientMixin {
  late int currentStep;
  late PageController _scrollController;

  @override
  void initState() {
    currentStep = 0;
    _scrollController = PageController(initialPage: currentStep);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _recapScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const BalanceGrowthSection(),
            const SizedBox(height: 20),
            const InOutSection(),
            const SizedBox(height: 20),
            const DistributionSection(),
            const SizedBox(height: 20),
            const LoansSection(),
            const SizedBox(height: 20),
            const GoalsSection(),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // _scrollController.animateToPage(1, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                  Navigator.of(context).pop();
                },
                child: const Text("Đã hiểu"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _reviewScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("page 2"),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _scrollController.animateToPage(0, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                      },
                      child: const Text("Quay lại"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Xong"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: StyleRes.defaultStyledAppBar(
        title: "Tổng kết tháng 4, 2024",
        onBackPressed: () => Navigator.of(context).pop(),
        trailings: [],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _scrollController,
        children: [
          _recapScreen(),
          _reviewScreen(),
        ],
      ),
    );
  }
}

class SummaryChartData {
  final String x;
  final List<int> y;

  SummaryChartData(this.x, this.y);
}
