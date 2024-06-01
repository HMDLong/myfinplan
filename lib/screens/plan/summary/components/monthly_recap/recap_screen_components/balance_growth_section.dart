import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/monthly_recap_screen.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/recap_section_title.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BalanceGrowthSection extends ConsumerWidget {
  const BalanceGrowthSection({super.key});

  Widget _buildRow(String title, int value, {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: filled ? Colors.blue.shade50 : Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: title, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(amountToCompact(value), style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = [
      SummaryChartData("1/2024", [90000000]),
      SummaryChartData("2/2024", [80000000]),
      SummaryChartData("3/2024", [100000000]),
      SummaryChartData("4/2024", [120530000]),
      SummaryChartData("5/2024", [0]),
      SummaryChartData("6/2024", [0]),
    ];
    return Column(
      children: [
        const RecapSectionTitle(title: "Tăng trưởng chung"),
        const SizedBox(height: 10),
        _buildRow("Gốc", 10000000),
        _buildRow("Dự kiến", 10000000, filled: true),
        _buildRow("Thực tế", 10000000),
        _buildRow("Chênh lệch", 10000000, filled: true),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: SfCartesianChart(
            title: ChartTitle(
              text: "Biến động số dư đến tháng 4/2024",
              textStyle: const TextStyle(fontSize: 12),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
            series: [
              ColumnSeries<SummaryChartData, String>(
                enableTooltip: true,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.blue.shade900,
                dataSource: data,
                xValueMapper: (data, i) => data.x,
                yValueMapper: (data, i) => data.y[0],
              ),
            ],
          ),
        ),
        Card(
          color: Colors.blue.shade50,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(children: [
              Text(
                "Đây là tháng thứ 2 liên tiếp số dư tăng trưởng. Từ tháng 3/2024 (${amountToDecimal(100000000)}) đã tăng ${amountToDecimal(120530000 - 100000000)} (+20.53%).",
                softWrap: true,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
