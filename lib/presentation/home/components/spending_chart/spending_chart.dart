import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/presentation/home/components/spending_chart/spending_chart_providers.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpendingChart extends StatefulWidget {
  const SpendingChart({
    super.key,
  });

  @override
  State<SpendingChart> createState() => _SpendingChartState();
}

BoxDecoration itemDecoration(Color color) => BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: color,
    );

BoxConstraints itemConstraints = const BoxConstraints(minHeight: 25);

class ColumnData {
  String x;
  num y;

  ColumnData(this.x, this.y);
}

class _SpendingChartState extends State<SpendingChart> {
  final timeMenuItems = <DropdownMenuEntry<TimeType>>[
    const DropdownMenuEntry(value: TimeType.week, label: "Tuần"),
    const DropdownMenuEntry(value: TimeType.month, label: "Tháng"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final currentTimeType = ref.watch(currentTimeTypeProvider);
            return Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.blue.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: timeMenuItems.map((e) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(currentTimeTypeProvider.notifier).state = e.value;
                      },
                      child: currentTimeType == e.value
                          ? Container(
                              constraints: itemConstraints,
                              decoration: itemDecoration(CupertinoColors.activeBlue),
                              child: Center(
                                child: Text(
                                  e.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              constraints: itemConstraints,
                              decoration: itemDecoration(Colors.transparent),
                              child: Center(
                                child: Text(
                                  e.label,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return ref.watch(spendingChartDataProvider).when(
                  data: (data) {
                    return SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
                        series: [
                          ColumnSeries<ColumnData, String>(
                            enableTooltip: true,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: CupertinoColors.activeBlue,
                            dataSource: data,
                            xValueMapper: (data, _) => data.x,
                            yValueMapper: (data, _) => data.y,
                            dataLabelMapper: (data, _) => NumberFormat.decimalPattern().format(data.y),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, _) => Text("$error"),
                  loading: () => const SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CircularProgressIndicator(),
                  ),
                );
          },
        ),
      ],
    );
  }
}
