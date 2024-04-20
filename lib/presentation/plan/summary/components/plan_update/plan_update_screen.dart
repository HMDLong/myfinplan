import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/presentation/statistics/widgets/category_pie_chart/category_pie_chart.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlanUpdateScreen extends StatefulWidget {
  const PlanUpdateScreen({super.key});

  @override
  State<PlanUpdateScreen> createState() => _PlanUpdateScreenState();
}

class _PlanUpdateScreenState extends State<PlanUpdateScreen> {
  late int currentStep;

  @override
  void initState() {
    currentStep = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = [
      SummaryChartData("1/2024", [90000000]),
      SummaryChartData("2/2024", [80000000]),
      SummaryChartData("3/2024", [100000000]),
      SummaryChartData("4/2024", [120530000]),
      SummaryChartData("5/2024", [0]),
      SummaryChartData("6/2024", [0]),
    ];
    final data2 = [
      SummaryChartData("Dự kiến", [8000000, 7000000]),
      SummaryChartData("Thực tế", [9000000, 7500000]),
    ];
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Tổng kết tháng 4, 2024",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Tăng trưởng chung",
            style: TextStyle(
              // fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                amountToDecimal(100000000, currency: null),
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: Colors.green,
              ),
              Text(
                amountToDecimal(120530000, currency: null),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 6),
              const Chip(
                avatar: Icon(
                  Icons.arrow_upward,
                  color: Colors.green,
                  size: 16,
                ),
                labelPadding: EdgeInsets.only(right: 4),
                label: Text(
                  "${(120530000 - 100000000) / 100000000 * 100} %",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // const SizedBox(height: 10),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: SfCartesianChart(
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
          const SizedBox(height: 10),
          const Text(
            "Thu chi",
            style: TextStyle(
              // fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: SfCartesianChart(
              isTransposed: true,
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
              series: [
                ColumnSeries<SummaryChartData, String>(
                  enableTooltip: true,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.green.shade600,
                  dataSource: data2,
                  xValueMapper: (data, i) => data.x,
                  yValueMapper: (data, i) => data.y[0],
                ),
                ColumnSeries<SummaryChartData, String>(
                  enableTooltip: true,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.red.shade400,
                  dataSource: data2,
                  xValueMapper: (data, i) => data.x,
                  yValueMapper: (data, i) => data.y[1],
                ),
              ],
            ),
          ),
          Card(
            color: Colors.blue.shade50,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Wrap(
                children: [
                  Text(
                    "Trong tháng 4/2024, bạn chi tổng cộng ${amountToDecimal(7500000)}, thu tổng cộng ${amountToDecimal(12000000)}. Chi phí của bạn chiếm ${7500000 / 12000000 * 100} % tổng thu nhập.",
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const Text(
            "Phân bố thu chi",
            style: TextStyle(
              // fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          CategoryPieChart(timeRange: TimeRange.rangeByType(TimeType.month)),
          Card(
            color: Colors.blue.shade50,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Wrap(
                children: [
                  Text(
                    "Trong tháng 4/2024, 3 chi phí lớn nhất là cho Ăn uống (${amountToDecimal(3000000)} = 30%), Tiền thuê nhà (${amountToDecimal(2500000)} = 25%) và Quần áo (${amountToDecimal(1000000)} = 10%).",
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Tín dụng",
            style: TextStyle(
              // fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            color: Colors.blue.shade50,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text("Mức sử dụng: "),
                      const SizedBox(width: 10),
                      Text("${amountToDecimal(5000000)}/${amountToDecimal(10000000)}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Đã trả:"),
                      SizedBox(width: 10),
                      Text("${amountToDecimal(3000000)}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Dư nợ kì này: "),
                      SizedBox(width: 10),
                      Text("${amountToDecimal(2000000)}"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Tổng nợ tín dụng kì sau: "),
                      SizedBox(width: 10),
                      Text("${amountToDecimal(2400000)}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.red.shade200,
                    child: Row(
                      children: [
                        Expanded(child: Icon(Icons.warning_amber_rounded)),
                        Expanded(flex: 4, child: Text("Dư nợ xấu: tổng nợ tín dụng tăng")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
