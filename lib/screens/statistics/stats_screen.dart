import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/statistics/stat_timerange_provider.dart';
import 'package:myfinplan/screens/statistics/widgets/account_dist_chart/account_dist_chart.dart';
import 'package:myfinplan/screens/statistics/widgets/expense_on_income.dart';
import 'package:myfinplan/screens/statistics/widgets/saving_progress_chart.dart';
import 'package:myfinplan/screens/statistics/widgets/saving_to_income_chart.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart.dart';
import 'package:myfinplan/shared_widgets/graphs/income_expense_chart.dart';
import 'package:myfinplan/shared_widgets/pickers/timerange_picker/timerange_picker.dart';
import 'package:myfinplan/screens/statistics/widgets/category_pie_chart/category_pie_chart.dart';
import 'package:myfinplan/utils/styles.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final tabs = [
    const Tab(text: "Số dư"),
    const Tab(text: "Thu chi"),
    const Tab(text: "Khác"),
  ];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTimeRange = ref.watch(statTimeRangeProvider);
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: defaultStyledAppBar(
        title: "Thống kê",
        bottom: TabBar.secondary(
          controller: tabController,
          tabs: tabs,
          labelColor: CupertinoColors.activeBlue,
          unselectedLabelColor: Colors.black87,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TimerangePicker(
              allowDay: false,
              onTimeChanged: (newTimeRange) {
                setState(() {
                  ref.read(statTimeRangeProvider.notifier).state = newTimeRange;
                });
              },
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildContentCard(
                          "Biến động số dư",
                          "Số dư của tôi thay đổi thế nào qua thời gian",
                          BalanceChart(chartHeight: 200, timeRange: currentTimeRange),
                        ),
                        const SizedBox(height: 10),
                        const AccountDistributionChart(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildContentCard(
                          "Tỉ lệ thu chi",
                          "Chi tiêu chiếm bao nhiêu thu nhập",
                          const ExpenseOnIncomeChart(),
                        ),
                        const SizedBox(height: 8),
                        _buildContentCard(
                          "Biến động thu chi",
                          "Thu chi của tôi thay đổi thế nào qua thời gian",
                          MoneyInOutChart(chartHeight: 200, timeRange: currentTimeRange),
                        ),
                        const SizedBox(height: 8),
                        CategoryPieChart(timeRange: currentTimeRange),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildContentCard(
                          "Tỉ lệ tiết kiệm",
                          "Tôi giành ra bao nhiêu để tiết kiệm từ thu nhập",
                          const SavingToIncomeChart(),
                        ),
                        const SizedBox(height: 8),
                        _buildContentCard(
                          "Tiến trình tiết kiệm",
                          "Tôi tiết kiệm như thế nào trong 6 tháng vừa qua",
                          const SavingProgressChart(),
                        ),
                        const SizedBox(height: 8),
                        _buildContentCard(
                          "Tình hình trả nợ",
                          "Tôi dành bao nhiêu tiết kiệm từ thu nhập",
                          const SizedBox(height: 40),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildContentCard(String title, String subtitle, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
