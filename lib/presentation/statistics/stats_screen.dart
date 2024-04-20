import 'package:flutter/material.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart/balance_chart.dart';
import 'package:myfinplan/shared_widgets/pickers/timerange_picker/timerange_picker.dart';
import 'package:myfinplan/presentation/statistics/widgets/category_pie_chart/category_pie_chart.dart';
import 'package:myfinplan/utils/time/times.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late TimeRange currentTimeRange;

  @override
  void initState() {
    currentTimeRange = TimeRange.rangeByType(TimeType.month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        children: [
          TimerangePicker(
            allowDay: false,
            onTimeChanged: (newTimeRange) {
              setState(() {
                currentTimeRange = newTimeRange;
              });
            },
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    "Biến động thu chi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Thu chi của tôi thay đổi như thế nào",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                BalanceChart(
                  chartHeight: 250,
                  timeRange: currentTimeRange,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CategoryPieChart(
            timeRange: currentTimeRange,
          ),
        ],
      ),
    );
  }
}
