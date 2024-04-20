import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:myfinplan/data/models/account/account.dart';

class BalanceChart<T extends Account> extends ConsumerStatefulWidget {
  final T? account;
  final TimeRange timeRange;
  final double chartHeight;
  const BalanceChart({
    super.key,
    this.account,
    required this.timeRange,
    this.chartHeight = 400,
  });

  @override
  ConsumerState<BalanceChart> createState() => _BalanceChartState<T>();
}

final getTransactionDataProvider = FutureProvider.family<List<Transaction>, String?>((ref, accountId) async {
  var transactions = await ref.watch(transactionNotifierProvider).getAllTransaction();
  if (accountId != null) {
    return transactions.where((transact) {
      return accountId == transact.transactAccountId || accountId == transact.targetAccountId;
    }).toList();
  }
  return transactions;
});

class _BalanceChartState<T extends Account> extends ConsumerState<BalanceChart> {
  final FilterSetting _filterSetting = FilterSetting(
    content: DisplayContentType.expense,
    // timeRange: TimeRange.rangeByType(TimeType.month),
    valueMode: DisplayValueMode.separated,
  );

  List<BalanceChartData<DateTime, int>> toChartSeries(List<Transaction> filterTransaction) {
    if (filterTransaction.isEmpty) {
      return widget.timeRange.getRangeDates().map((e) {
        return BalanceChartData(x: e, y: 0);
      }).toList();
    }
    final groupByDateData = filterTransaction.fold(<DateTime, int>{}, (previousValue, transact) {
      final dateOnly = transact.timestamp.toDateOnly();
      previousValue[dateOnly] = (previousValue[dateOnly] ?? 0) + transact.amount.abs();
      return previousValue;
    });
    var chartData = <BalanceChartData<DateTime, int>>[];
    for (var date in widget.timeRange.getRangeDates()) {
      chartData.add(BalanceChartData(x: date, y: groupByDateData[date] ?? 0));
    }
    chartData.sort((a, b) {
      if (a.x.isAfter(b.x)) return 1;
      if (a.x.isBefore(b.x)) return -1;
      return 0;
    });
    // merge points
    if (chartData.length > 60) {
      final tmp = <BalanceChartData<DateTime, int>>[];
      for (var month = 1; month <= 12; month++) {
        final daysInMonth = chartData.where((e) => e.x.month == month).toList();
        final monthAvg = daysInMonth.fold(0, (prev, e) => prev + e.y) / daysInMonth.length;
        tmp.add(BalanceChartData(x: daysInMonth.first.x, y: monthAvg.toInt()));
      }
      chartData = tmp;
    }
    // accmulate tranformation
    if (_filterSetting.valueMode == DisplayValueMode.accumulate) {
      final accumulateChartData = <BalanceChartData<DateTime, int>>[chartData.first];
      final tomorrow = DateTime.now().toDateOnly().add(const Duration(days: 1));
      for (var data in chartData.skip(1)) {
        accumulateChartData.add(BalanceChartData<DateTime, int>(
          x: data.x,
          y: tomorrow.isAfter(data.x) ? accumulateChartData.last.y + data.y : 0,
        ));
      }
      return accumulateChartData;
    }
    return chartData;
  }

  List<Transaction> filterTransaction(Iterable<Transaction> values) {
    return values
        .where((transaction) => switch (_filterSetting.content) {
              DisplayContentType.expense => transaction.transactType == TransactionType.expense,
              DisplayContentType.income => transaction.transactType == TransactionType.income,
              DisplayContentType.balance => true,
            })
        .where((transaction) => widget.timeRange.contain(transaction.timestamp) && transaction.paid)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final seriesToDisplay = ref.watch(getTransactionDataProvider(widget.account?.id)).when<List<BalanceChartData<DateTime, int>>>(
          data: (data) => toChartSeries(filterTransaction(data)),
          error: (error, _) => [],
          loading: () => [],
        );
    return Column(
      children: [
        SizedBox(
          height: widget.chartHeight,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              plotOffset: 10.0,
              labelPlacement: LabelPlacement.onTicks,
              labelAlignment: LabelAlignment.center,
            ),
            primaryYAxis: NumericAxis(
              plotOffset: 5.0,
              majorGridLines: const MajorGridLines(),
              numberFormat: NumberFormat.compact(),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enablePanning: true,
              zoomMode: ZoomMode.x,
            ),
            series: <SplineSeries<BalanceChartData<DateTime, int>, String>>[
              SplineSeries<BalanceChartData<DateTime, int>, String>(
                dataSource: seriesToDisplay,
                xValueMapper: (BalanceChartData<DateTime, int> data, _) => DateFormat.MMMd().format(data.x),
                yValueMapper: (BalanceChartData<DateTime, int> data, _) => data.y,
                color: switch (_filterSetting.content) {
                  DisplayContentType.expense => Colors.red.shade300,
                  DisplayContentType.income => Colors.green,
                  DisplayContentType.balance => Colors.blue,
                },
                // borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Row(
            children: [
              const Text("Biểu đồ"),
              const SizedBox(
                width: 10,
              ),
              DropdownButton<DisplayContentType>(
                  value: _filterSetting.content,
                  // style: TextStyle(fontSize: 12, color: Colors.black),
                  items: const [
                    DropdownMenuItem(value: DisplayContentType.balance, child: Text("Số dư")),
                    DropdownMenuItem(value: DisplayContentType.expense, child: Text("Chi phí")),
                    DropdownMenuItem(value: DisplayContentType.income, child: Text("Thu nhập")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filterSetting.content = value;
                      });
                    }
                  }),
              const SizedBox(
                width: 20,
              ),
              const Text("Loại"),
              const SizedBox(
                width: 10,
              ),
              DropdownButton<DisplayValueMode>(
                  value: _filterSetting.valueMode,
                  // style: TextStyle(fontSize: 12, color: Colors.black),
                  items: const [
                    DropdownMenuItem(value: DisplayValueMode.accumulate, child: Text("Tích lũy")),
                    DropdownMenuItem(value: DisplayValueMode.separated, child: Text("Độc lập")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filterSetting.valueMode = value;
                      });
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class FilterSetting {
  DisplayContentType content;
  // TimeRange timeRange;
  DisplayValueMode valueMode;

  FilterSetting({
    required this.content,
    // required this.timeRange,
    this.valueMode = DisplayValueMode.accumulate,
  });

  FilterSetting copyWith({
    DisplayContentType? content,
    TimeRange? timeRange,
    DisplayValueMode? valueMode,
  }) {
    return FilterSetting(
      content: content ?? this.content,
      // timeRange: timeRange ?? this.timeRange,
      valueMode: valueMode ?? this.valueMode,
    );
  }
}

enum DisplayValueMode { separated, accumulate }

enum DisplayContentType {
  balance,
  expense,
  income,
}

class BalanceChartData<T, R> {
  T x;
  R y;

  BalanceChartData({
    required this.x,
    required this.y,
  });
}
