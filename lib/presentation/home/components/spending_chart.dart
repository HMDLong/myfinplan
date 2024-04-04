import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/utils/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpendingChart extends ConsumerStatefulWidget {
  const SpendingChart({
    super.key,
  });

  @override
  ConsumerState<SpendingChart> createState() => _SpendingChartState();
}

final timeMenuItems = <DropdownMenuEntry<TimeType>>[
  const DropdownMenuEntry(value: TimeType.day, label: "Ngày"),
  const DropdownMenuEntry(value: TimeType.week, label: "Tuần"),
  const DropdownMenuEntry(value: TimeType.month, label: "Tháng"),
];

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

class _SpendingChartState extends ConsumerState<SpendingChart> {
  late TimeType _currentType;

  @override
  void initState() {
    _currentType = TimeType.day;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                    setState(() {
                      _currentType = e.value;
                    });
                  },
                  child: _currentType == e.value
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
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
            series: [
              ColumnSeries<ColumnData, String>(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: CupertinoColors.activeBlue,
                dataSource: [
                  ColumnData(
                    getRangeOfTheMonth().toString(),
                    10000000,
                  ),
                  ColumnData(
                    getPreviousMonthRangeByRange(range: getRangeOfTheMonth()).toString(),
                    15000000,
                  ),
                ],
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
