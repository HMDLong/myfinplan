import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/home/components/spending_chart/spending_chart.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

final currentTimeTypeProvider = StateProvider((ref) => TimeType.month);

final spendingChartDataProvider = FutureProvider<List<ColumnData>>(
  (ref) async {
    final transacts = await ref.watch(transactionNotifierProvider).getAllTransaction();
    final timeRange = TimeRange.rangeByType(ref.watch(currentTimeTypeProvider));
    final prevRange = timeRange.previous();
    final res = transacts.where((e) {
      return e.paid && e.transactType == TransactionType.expense && (timeRange.contain(e.timestamp!) || prevRange.contain(e.timestamp!));
    }).fold([0, 0], (prev, e) {
      if (prevRange.contain(e.timestamp!)) {
        prev[0] += e.amount.abs();
      } else {
        prev[1] += e.amount.abs();
      }
      return prev;
    });
    return [
      ColumnData(timeRange.timeType == TimeType.month ? "Tháng trước" : "Tuần trước", res[0]),
      ColumnData(timeRange.timeType == TimeType.month ? "Tháng này" : "Tuần này", res[1]),
    ];
  },
);
