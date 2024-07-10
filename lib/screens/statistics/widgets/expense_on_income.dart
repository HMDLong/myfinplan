import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transact_type/transaction_type.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/statistics/stat_timerange_provider.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final expenseOnIncomeDataProvider = FutureProvider<List<int>>((ref) async {
  final range = ref.watch(statTimeRangeProvider);
  final transacts = await ref.watch(transactionNotifierProvider).getAllTransaction();
  final matchTransacts = transacts.where((e) => e.paid && range.contain(e.timestamp));
  final totalExpense = matchTransacts.where((e) => e.transactType == TransactionType.expense).fold(0, (prev, transact) {
    return prev + transact.amount.abs();
  });
  final totalIncome = matchTransacts.where((e) => e.transactType == TransactionType.income).fold(0, (prev, transact) {
    return prev + transact.amount.abs();
  });
  return [totalExpense, totalIncome];
});

const dataStyle = TextStyle(fontSize: 12);

class ExpenseOnIncomeChart extends ConsumerWidget {
  const ExpenseOnIncomeChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(expenseOnIncomeDataProvider).when(
          data: (data) {
            return Row(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      series: [
                        PieSeries(
                          radius: "50%",
                          dataSource: data,
                          xValueMapper: (datum, index) => datum.toString(),
                          yValueMapper: (datum, index) => datum,
                          pointColorMapper: (datum, index) => index == 1 ? Colors.grey.shade300 : Colors.green.shade400,
                          explode: true,
                          explodeIndex: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tổng chi tiêu chiếm"),
                      const SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${data[0] * 100 ~/ (data[0] + data[1])}%",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: "  thu nhập"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text("Chi phí", style: dataStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(Formatter.amountToDecimal(data[0]), style: dataStyle),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text("Thu nhập", style: dataStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(Formatter.amountToDecimal(data[1]), style: dataStyle),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (error, _) {
            return const Center(
              child: Text("Đã có lỗi xảy ra"),
            );
          },
          loading: () => const Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
