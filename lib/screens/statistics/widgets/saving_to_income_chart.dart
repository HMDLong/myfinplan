import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/services/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/statistics/stat_timerange_provider.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final savingOnIncomeProvider = FutureProvider<List<int>>((ref) async {
  final range = ref.watch(statTimeRangeProvider);
  final transacts = await ref.watch(transactionNotifierProvider).getAllTransaction();
  final totalSaving = transacts.where((e) => e.paid && e.categoryId == SpecialCategory.saving && range.contain(e.timestamp)).fold(0, (prev, transact) {
    return prev + transact.amount.abs();
  });
  final totalIncome = transacts.where((e) => e.paid && e.transactType == TransactionType.income && range.contain(e.timestamp)).fold(0, (prev, transact) {
    return prev + transact.amount.abs();
  });
  return [totalSaving, totalIncome];
});

const dataStyle = TextStyle(fontSize: 12);

class SavingToIncomeChart extends ConsumerWidget {
  const SavingToIncomeChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(savingOnIncomeProvider).when(
          data: (data) {
            final hasData = data[1] != 0;
            return Row(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      series: [
                        hasData
                            ? PieSeries(
                                radius: "50%",
                                dataSource: data,
                                xValueMapper: (datum, index) => datum.toString(),
                                yValueMapper: (datum, index) => datum,
                                pointColorMapper: (datum, index) => index == 0 ? Colors.green.shade400 : Colors.grey.shade300,
                                explode: true,
                                explodeIndex: 0,
                              )
                            : PieSeries(
                                radius: "50%",
                                dataSource: [1],
                                xValueMapper: (datum, index) => datum.toString(),
                                yValueMapper: (datum, index) => datum,
                                pointColorMapper: (datum, index) => Colors.grey.shade200,
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
                      if (hasData) const Text("Tổng tiết kiệm chiếm"),
                      const SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                          children: hasData
                              ? [
                                  TextSpan(
                                    text: "${data[0] * 100 ~/ data[1]}%",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(text: "  thu nhập"),
                                ]
                              : [
                                  const TextSpan(text: "Không đủ dữ liệu"),
                                ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text("Tiết kiệm", style: dataStyle),
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
