import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/statistics/stat_timerange_provider.dart';
import 'package:myfinplan/screens/statistics/widgets/account_dist_chart/account_dist_chart.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart.dart';
import 'package:myfinplan/shared_widgets/graphs/income_expense_chart.dart';
import 'package:myfinplan/shared_widgets/pickers/timerange_picker/timerange_picker.dart';
import 'package:myfinplan/screens/statistics/widgets/category_pie_chart/category_pie_chart.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
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

  @override
  Widget build(BuildContext context) {
    final currentTimeRange = ref.watch(statTimeRangeProvider);
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text(
          "Thống kê",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              _buildContentCard(
                "Biến động số dư",
                "Số dư của tôi thay đổi thế nào qua thời gian",
                BalanceChart(chartHeight: 200, timeRange: currentTimeRange),
              ),
              const SizedBox(height: 10),
              _buildContentCard(
                "Biến động thu chi",
                "Thu chi của tôi thay đổi thế nào qua thời gian",
                MoneyInOutChart(chartHeight: 200, timeRange: currentTimeRange),
              ),
              const SizedBox(height: 10),
              CategoryPieChart(timeRange: currentTimeRange),
              const AccountDistributionChart(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
