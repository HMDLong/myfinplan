import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/constants/predefined_categories.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const DEFAULT_SAVING_CHART_MONTH_SPAN = 6;

class SavingProgressModel {
  final List<Transaction> data;

  Map<DateTime, int> get chartData {
    final res = <DateTime, int>{};
    var range = TimeRange.rangeByType(TimeType.month);
    for (var i = 1; i <= DEFAULT_SAVING_CHART_MONTH_SPAN; i++) {
      res[range.start] = data.where((e) => range.contain(e.timestamp)).fold(0, (prev, e) => prev + e.amount.abs());
      range = range.previous();
    }
    return res;
  }

  SavingProgressModel(this.data);
}

final savingProgressDataProvider = FutureProvider((ref) async {
  // final planRange = ref.watch(statTimeRangeProvider);
  final statRange = TimeRange.lastNofTimeType(TimeType.month, DEFAULT_SAVING_CHART_MONTH_SPAN);
  final transacts = await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.transact);
  final savings = transacts.where((e) => e.paid && e.categoryId == SpecialCategory.saving && statRange.contain(e.timestamp)).toList();
  return SavingProgressModel(savings);
});

class SavingProgressChart extends ConsumerWidget {
  const SavingProgressChart({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: ref.watch(savingProgressDataProvider).when(
            data: (data) {
              return SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: 45,
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compact(),
                ),
                series: [
                  ColumnSeries<MapEntry, String>(
                    emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
                    dataSource: data.chartData.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
                    xValueMapper: (data, i) => Formatter.toMonthYear(data.key),
                    yValueMapper: (data, i) => data.value,
                  ),
                ],
              );
            },
            error: (error, _) => const Center(
              child: Text("error"),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
