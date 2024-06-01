import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/screens/plan/summary/providers/summary_data_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const borderRadius = BorderRadius.only(
  topLeft: Radius.circular(4),
  topRight: Radius.circular(4),
);

class SummaryChart extends StatefulWidget {
  const SummaryChart({super.key});

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(summaryDataProvider).when(
              data: (data) {
                final chartData = [
                  SummaryEntry("Dự kiến", data[0], data[2], data[4], data[6]),
                  SummaryEntry("Thực tế", data[1], data[3], data[5], data[7]),
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
                      itemPadding: 10,
                      overflowMode: LegendItemOverflowMode.wrap,
                      textStyle: TextStyle(fontSize: 12),
                    ),
                    series: [
                      StackedColumnSeries<SummaryEntry, String>(
                        name: "Thu nhập",
                        groupName: "Thu nhập",
                        dataSource: chartData,
                        xValueMapper: (data, i) => data.label,
                        yValueMapper: (data, i) => data.income,
                        enableTooltip: true,
                        spacing: 0.2,
                      ),
                      StackedColumnSeries<SummaryEntry, String>(
                        name: "Chi bắt buộc",
                        groupName: "Chi phí",
                        dataSource: chartData,
                        xValueMapper: (data, i) => data.label,
                        yValueMapper: (data, i) => data.mustExpense,
                        enableTooltip: true,
                        spacing: 0.2,
                      ),
                      StackedColumnSeries<SummaryEntry, String>(
                        name: "Chi cá nhân",
                        groupName: "Chi phí",
                        dataSource: chartData,
                        xValueMapper: (data, i) => data.label,
                        yValueMapper: (data, i) => data.mayExpense,
                        enableTooltip: true,
                        spacing: 0.2,
                      ),
                      StackedColumnSeries<SummaryEntry, String>(
                        name: "Tiết kiệm",
                        groupName: "Chi phí",
                        dataSource: chartData,
                        xValueMapper: (data, i) => data.label,
                        yValueMapper: (data, i) => data.saving,
                        enableTooltip: true,
                        spacing: 0.2,
                      ),
                    ],
                  ),
                );
              },
              error: (error, _) => Text("$error"),
              loading: () => const CircularProgressIndicator(),
            );
      },
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
