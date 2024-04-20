import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SummaryChart extends StatefulWidget {
  const SummaryChart({super.key});

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  @override
  Widget build(BuildContext context) {
    final chartData = [
      SummaryEntry("Dự kiến", 10000000, 7000000, 2000000, 1000000),
      SummaryEntry("Thực tế", 6000000, 4000000, 1000000, 0),
    ];
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.compact(),
        ),
        legend: const Legend(
          isVisible: true,
          // position: LegendPosition.bottom,
          itemPadding: 10,
          overflowMode: LegendItemOverflowMode.wrap,
          textStyle: TextStyle(fontSize: 12),
        ),
        series: [
          StackedColumnSeries<SummaryEntry, String>(
            name: "Thu nhập",
            groupName: "Thu nhập",
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            dataSource: chartData,
            xValueMapper: (data, i) => data.label,
            yValueMapper: (data, i) => data.income,
            enableTooltip: true,
            // width: 0.5,
            spacing: 0.2,
          ),
          StackedColumnSeries<SummaryEntry, String>(
            name: "Chi bắt buộc",
            groupName: "Chi phí",
            dataSource: chartData,
            xValueMapper: (data, i) => data.label,
            yValueMapper: (data, i) => data.mustExpense,
            enableTooltip: true,
            // width: 0.5,
            spacing: 0.2,
          ),
          StackedColumnSeries<SummaryEntry, String>(
            name: "Chi cá nhân",
            groupName: "Chi phí",
            dataSource: chartData,
            xValueMapper: (data, i) => data.label,
            yValueMapper: (data, i) => data.mayExpense,
            enableTooltip: true,
            // width: 0.5,
            spacing: 0.2,
          ),
          StackedColumnSeries<SummaryEntry, String>(
            name: "Tiết kiệm",
            groupName: "Chi phí",
            dataSource: chartData,
            xValueMapper: (data, i) => data.label,
            yValueMapper: (data, i) => data.saving,
            enableTooltip: true,
            // width: 0.5,
            spacing: 0.2,
          ),
        ],
      ),
    );
  }
}

class SummaryEntry {
  String label;
  int income;
  int mustExpense;
  int mayExpense;
  int saving;

  SummaryEntry(
    this.label,
    this.income,
    this.mustExpense,
    this.mayExpense,
    this.saving,
  );
}
