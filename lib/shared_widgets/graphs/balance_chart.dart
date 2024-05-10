import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/providers/accounts/accounts/account_usecases.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:myfinplan/data/models/account/account.dart';

class BalanceChart<T extends Account> extends ConsumerStatefulWidget {
  final T? account;
  final TimeRange timeRange;
  final double chartHeight;
  final bool balanceOnly;
  const BalanceChart({
    super.key,
    this.account,
    required this.timeRange,
    this.chartHeight = 400,
    this.balanceOnly = false,
  });

  @override
  ConsumerState<BalanceChart> createState() => _BalanceChartState<T>();
}

final balanceChartTimeRangeProvider = StateProvider((ref) => TimeRange.lastNDays(60));

final getTransactionDataProvider = FutureProvider.family<List<BalanceChartData<DateTime, int>>, String?>((ref, accountId) async {
  var transacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) {
    final matchAccount = accountId == null ? true : (accountId == e.accId || accountId == e.toAccId);
    return matchAccount && e.paid;
  }).toList();
  int balance = 0;
  if (accountId != null) {
    balance = (await ref.watch(accountsProvider).getAccountById(accountId))!.usableBalance;
  } else {
    balance = ref.watch(totalBalanceProvider).when(
          data: (data) => data,
          error: (error, stackTrace) => throw Exception("$error"),
          loading: () => 0,
        );
  }
  final timeRange = ref.watch(balanceChartTimeRangeProvider);
  if (transacts.isEmpty) {
    return timeRange.getRangeDates().map((e) {
      return BalanceChartData(x: e, y: balance);
    }).toList();
  }
  final groupByDateData = transacts
      .fold(<DateTime, int>{}, (previousValue, transact) {
        final dateOnly = transact.timestamp.toDateOnly();
        previousValue[dateOnly] = (previousValue[dateOnly] ?? 0) + transact.amount;
        return previousValue;
      })
      .entries
      .toList()
    ..sort((a, b) => b.key.compareTo(a.key));
  var chartData = <BalanceChartData<DateTime, int>>[];
  int traceBalance = balance;
  for (var dateData in groupByDateData) {
    if (timeRange.start.isBefore(dateData.key)) {
      chartData.insert(0, BalanceChartData(x: dateData.key, y: traceBalance));
    }
    traceBalance -= dateData.value;
  }
  chartData = chartData.takeWhile((value) => value.x.isBefore(timeRange.end)).toList();
  // merge points
  // if (chartData.length > 60) {
  //   final tmp = <BalanceChartData<DateTime, int>>[];
  //   for (var month = 1; month <= 12; month++) {
  //     final daysInMonth = chartData.where((e) => e.x.month == month).toList();
  //     if (daysInMonth.isEmpty) continue;
  //     final monthAvg = daysInMonth.fold(0, (prev, e) => prev + e.y) / daysInMonth.length;
  //     tmp.add(BalanceChartData(x: daysInMonth.first.x, y: monthAvg.toInt()));
  //   }
  //   chartData = tmp;
  // }
  return chartData;
});

class _BalanceChartState<T extends Account> extends ConsumerState<BalanceChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.chartHeight,
      child: ref.watch(getTransactionDataProvider(widget.account?.id)).when(
            data: (data) {
              return SfCartesianChart(
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
                series: [
                  AreaSeries<BalanceChartData<DateTime, int>, String>(
                    dataSource: data,
                    xValueMapper: (BalanceChartData<DateTime, int> data, _) {
                      return DateFormat.MMMd().format(data.x);
                      //data.x;
                    },
                    yValueMapper: (BalanceChartData<DateTime, int> data, _) => data.y,
                    borderColor: CupertinoColors.activeBlue,
                    borderWidth: 1,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade200, Colors.blue],
                      stops: const [0.0, 0.5, 1.0],
                      transform: const GradientRotation(3 * math.pi / 2),
                    ),
                    // width: 0.5,
                    // borderRadius: const BorderRadius.only(
                    //   topLeft: Radius.circular(4),
                    //   topRight: Radius.circular(4),
                    // ),
                  ),
                ],
              );
            },
            error: (error, _) => Text("$error"),
            loading: () => const CircularProgressIndicator(),
          ),
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
