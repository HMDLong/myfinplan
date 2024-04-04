import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/utils/times.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryPieChart extends ConsumerStatefulWidget {
  final TimeRange timeRange;
  const CategoryPieChart({
    super.key,
    required this.timeRange,
  });

  @override
  ConsumerState<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends ConsumerState<CategoryPieChart> {
  bool displayParentCategory = true;
  ChartData? selectedData;
  TransactionType type = TransactionType.expense;

  @override
  Widget build(BuildContext context) {
    final int spentAmount = 1000000;
    final int totalAmount = 1000;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thành phần thu chi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Thu chi của tôi cho những gì?",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.3),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        type = TransactionType.expense;
                      });
                    },
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: type == TransactionType.expense ? CupertinoColors.activeBlue : Colors.white),
                      child: Center(
                        child: Text(
                          "Chi phí",
                          style: TextStyle(color: type == TransactionType.expense ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          type = TransactionType.income;
                        });
                      },
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: type == TransactionType.income ? CupertinoColors.activeBlue : Colors.white),
                        child: Center(
                          child: Text(
                            "Thu nhập",
                            style: TextStyle(color: type == TransactionType.income ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedData?.x ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${NumberFormat.decimalPattern().format(spentAmount)} VND (${(spentAmount / totalAmount * 100).toStringAsFixed(2)} %)",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: SfCircularChart(
                legend: const Legend(
                    isVisible: true,
                    isResponsive: true,
                    textStyle: TextStyle(fontSize: 10),
                    position: LegendPosition.bottom,
                    itemPadding: 10,
                    shouldAlwaysShowScrollbar: true,
                    overflowMode: LegendItemOverflowMode.wrap),
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    onPointTap: (pointInteractionDetails) {},
                    dataSource: [],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    explode: true,
                    dataLabelSettings: const DataLabelSettings(
                      showZeroValue: false,
                      showCumulativeValues: true,
                      isVisible: false,
                    ),
                    legendIconType: LegendIconType.circle,
                    dataLabelMapper: (datum, index) => datum.x,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.categoryId);
  final String x;
  final num y;
  final String categoryId;
}
