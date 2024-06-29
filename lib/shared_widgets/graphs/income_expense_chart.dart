import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/statistics/stat_timerange_provider.dart';
import 'package:myfinplan/shared_widgets/menu/menu.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:myfinplan/data/models/account/account.dart';

import '../../utils/time/date_time_ext.dart';

class MoneyInOutChart<T extends Account> extends ConsumerStatefulWidget {
  final T? account;
  final TimeRange timeRange;
  final double chartHeight;
  final bool balanceOnly;
  const MoneyInOutChart({
    super.key,
    this.account,
    required this.timeRange,
    this.chartHeight = 400,
    this.balanceOnly = false,
  });

  @override
  ConsumerState<MoneyInOutChart> createState() => _MoneyInOutChartState<T>();
}

final inOutChartContentTypeProvider = StateProvider((ref) => TransactionType.expense);

final getTransactionDataProvider = FutureProvider<List<InOutChartData<DateTime, int>>>((ref) async {
  final statTimeRange = ref.watch(statTimeRangeProvider);
  final content = ref.watch(inOutChartContentTypeProvider);
  var transacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) {
    return e.paid && e.transactType == content && statTimeRange.contain(e.timestamp!);
  }).toList();
  if (transacts.isEmpty) {
    return statTimeRange.getRangeDates().map((e) {
      return InOutChartData(x: e, y: 0);
    }).toList();
  }
  final groupByDateData = transacts.fold(<DateTime, int>{}, (previousValue, transact) {
    final dateOnly = transact.timestamp!.toDateOnly();
    previousValue[dateOnly] = (previousValue[dateOnly] ?? 0) + transact.amount.abs();
    return previousValue;
  });
  var chartData = <InOutChartData<DateTime, int>>[];
  for (var date in statTimeRange.getRangeDates()) {
    chartData.add(InOutChartData(x: date, y: groupByDateData[date] ?? 0));
  }
  chartData.sort((a, b) {
    if (a.x.isAfter(b.x)) return 1;
    if (a.x.isBefore(b.x)) return -1;
    return 0;
  });
  // merge points
  if (chartData.length > 60) {
    final tmp = <InOutChartData<DateTime, int>>[];
    for (var month = 1; month <= 12; month++) {
      final daysInMonth = chartData.where((e) => e.x.month == month).toList();
      final monthAvg = daysInMonth.fold(0, (prev, e) => prev + e.y) / daysInMonth.length;
      tmp.add(InOutChartData(x: daysInMonth.first.x, y: monthAvg.toInt()));
    }
    chartData = tmp;
  }
  return chartData;
});

class _MoneyInOutChartState<T extends Account> extends ConsumerState<MoneyInOutChart> {
  Color _getColor(TransactionType type) {
    return switch (type) {
      TransactionType.expense => Colors.red,
      TransactionType.income => Colors.green,
      _ => throw Exception("Not for transfer type"),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return CustomMenu<TransactionType>(
                items: const [
                  DropdownMenuEntry(value: TransactionType.expense, label: "Chi phí"),
                  DropdownMenuEntry(value: TransactionType.income, label: "Thu nhập"),
                ],
                onChanged: (value) {
                  ref.read(inOutChartContentTypeProvider.notifier).state = value;
                },
              );
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: widget.chartHeight,
            child: ref.watch(getTransactionDataProvider).when(
                  data: (data) {
                    final content = ref.watch(inOutChartContentTypeProvider);
                    return SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        plotOffset: 10.0,
                        labelPlacement: LabelPlacement.onTicks,
                        labelAlignment: LabelAlignment.center,
                        interactiveTooltip: const InteractiveTooltip(enable: true),
                      ),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                        // plotOffset: 5.0,
                        // majorGridLines: const MajorGridLines(),
                        // numberFormat: NumberFormat.compact(),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        enablePanning: true,
                        zoomMode: ZoomMode.x,
                      ),
                      series: [
                        ColumnSeries<InOutChartData<DateTime, int>, String>(
                          name: "Thu chi",
                          dataSource: data,
                          xValueMapper: (InOutChartData<DateTime, int> data, _) => Formatter.toMonthDate(data.x),
                          yValueMapper: (InOutChartData<DateTime, int> data, _) => data.y,
                          color: _getColor(content),
                          enableTooltip: true,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, _) => Text("$error"),
                  loading: () => const CircularProgressIndicator(),
                ),
          ),
        ],
      ),
    );
  }
}

enum DisplayValueMode { separated, accumulate }

class InOutChartData<T, R> {
  T x;
  R y;

  InOutChartData({
    required this.x,
    required this.y,
  });
}
