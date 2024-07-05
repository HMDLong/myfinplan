import 'dart:developer';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/services/accounts/accounts/account_usecases.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:myfinplan/data/models/account/account.dart';

import '../../utils/time/date_time_ext.dart';

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

final getTransactionDataProvider = FutureProvider.family<List<BalanceChartData<DateTime, int>>, BalanceChartInfo>((ref, info) async {
  var transacts = (await ref.watch(transactionNotifierProvider).getAllTransaction()).where((e) {
    final matchAccount = info.accountId == null ? true : (info.accountId == e.srcAccId || info.accountId == e.toAccId);
    return matchAccount && e.paid;
  }).toList();
  int balance = 0;
  if (info.accountId != null) {
    balance = (await ref.watch(accountsProvider).getAccountById(info.accountId!))!.usableBalance;
  } else {
    balance = ref.watch(totalBalanceProvider).when(
          data: (data) => data,
          error: (error, stackTrace) => throw Exception("$error"),
          loading: () => 0,
        );
  }
  if (transacts.isEmpty) {
    return info.timeRange.getRangeDates().map((e) {
      return BalanceChartData(x: e, y: balance);
    }).toList();
  }
  final groupByDateData = transacts.fold(<DateTime, int>{}, (previousValue, transact) {
    final dateOnly = transact.timestamp.toDateOnly();
    previousValue[dateOnly] = (previousValue[dateOnly] ?? 0) +
        transact.amount *
            (transact.transactType != TransactionType.transact
                ? 1
                : transact.toAccId == info.accountId
                    ? 1
                    : -1);
    return previousValue;
  });
  var chartData = <BalanceChartData<DateTime, int>>[];
  int traceBalance = balance -
      groupByDateData.entries.where((transactsByDate) {
        return transactsByDate.key.isAfter(info.timeRange.start);
      }).fold(0, (prev, e) => prev + e.value);
  for (var date in info.timeRange.getRangeDates()) {
    chartData.add(BalanceChartData(x: date, y: traceBalance));
    traceBalance += groupByDateData[date] ?? 0;
  }
  // for (var dateData in groupByDateData) {
  //   if (info.timeRange.start.isBefore(dateData.key)) {
  //     chartData.insert(0, BalanceChartData(x: dateData.key, y: traceBalance));
  //   }
  //   traceBalance -= dateData.value;
  // }
  // chartData = chartData.takeWhile((value) => value.x.isBefore(info.timeRange.end)).toList();
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
    return ref
        .watch(getTransactionDataProvider(
          BalanceChartInfo(
            timeRange: widget.timeRange,
            accountId: widget.account?.id,
          ),
        ))
        .when(
          data: (data) {
            final sortedByAmount = List<BalanceChartData<DateTime, int>>.from(data)..sort((a, b) => b.y.compareTo(a.y));
            final sortedByTime = List<BalanceChartData<DateTime, int>>.from(data)..sort((a, b) => a.x.compareTo(b.x));
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
                      axisLine: const AxisLine(width: 0),
                      plotOffset: 4.0,
                      majorGridLines: const MajorGridLines(),
                      numberFormat: NumberFormat.compact(),
                    ),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      shouldAlwaysShow: true,
                      lineDashArray: const [10, 10],
                      activationMode: ActivationMode.singleTap,
                      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    ),
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      zoomMode: ZoomMode.x,
                    ),
                    series: [
                      AreaSeries<BalanceChartData<DateTime, int>, String>(
                        dataSource: data,
                        xValueMapper: (BalanceChartData<DateTime, int> data, _) => Formatter.toMonthDate(data.x),
                        yValueMapper: (BalanceChartData<DateTime, int> data, _) => data.y,
                        borderColor: CupertinoColors.activeBlue,
                        borderWidth: 1,
                        enableTooltip: true,
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.blue.shade200, Colors.blue],
                          stops: const [0.3, 0.7, 1.0],
                          transform: const GradientRotation(3 * math.pi / 2),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpandableNotifier(
                  child: ScrollOnExpand(
                    child: Expandable(
                      collapsed: ExpandableButton(
                        child: const SizedBox(
                          child: Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      expanded: Column(
                        children: [
                          _row("Cao nhất", "${Formatter.amountToDecimal(sortedByAmount.first.y)} (${Formatter.toStandartDate(sortedByAmount.first.x)})"),
                          _row("Thấp nhất", "${Formatter.amountToDecimal(sortedByAmount.last.y)} (${Formatter.toStandartDate(sortedByAmount.last.x)})"),
                          _row("Trung bình", Formatter.amountToDecimal((sortedByTime.last.y - sortedByTime.first.y) ~/ sortedByTime.length)),
                          ExpandableButton(
                            child: const SizedBox(
                              child: Icon(
                                Icons.arrow_drop_up_sharp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
          error: (error, _) => Text("$error"),
          loading: () => const CircularProgressIndicator(),
        );
  }

  _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterSetting {
  DisplayContentType content;
  DisplayValueMode valueMode;

  FilterSetting({
    required this.content,
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

enum DisplayContentType { balance, expense, income }

class BalanceChartData<T, R> {
  T x;
  R y;

  BalanceChartData({
    required this.x,
    required this.y,
  });
}

class BalanceChartInfo with EquatableMixin {
  String? accountId;
  TimeRange timeRange;

  BalanceChartInfo({this.accountId, required this.timeRange});

  @override
  List<Object?> get props => [accountId, timeRange];

  @override
  bool? get stringify => true;
}
