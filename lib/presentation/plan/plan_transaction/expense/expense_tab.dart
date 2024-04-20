import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';

class ExpenseTab extends ConsumerStatefulWidget {
  const ExpenseTab({super.key});

  @override
  ConsumerState<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends ConsumerState<ExpenseTab> {
  int _currentTab = 0;

  List<Transaction> _getTransactionToDisplay(List<Transaction> planTransacts) {
    return planTransacts.where((transact) {
      return switch (_currentTab) { 0 => transact.paid == false, 1 => transact.paid == true, 2 => true, _ => false };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final expenses = [];

    final totalExpense = 1000000000;
    final actualExpense = 10000;
    final today = DateTime.now();
    return expenses.isEmpty
        ? const SizedBox.expand(
            child: Center(
              child: Text("Bạn chưa thiết lập khoản chi tiêu"),
            ),
          )
        : ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tổng chi tiêu Th${today.month} ${today.year}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Text(
                    //   "${NumberFormat.decimalPattern().format(actualExpense)}/${NumberFormat.decimalPattern().format(totalExpense)} VND",
                    //   style: const TextStyle(fontSize: 18),
                    // ),
                    LinearProgressGauge(
                      value: actualExpense.abs(),
                      max: totalExpense.abs(),
                      mode: GaugeMode.limit,
                      leadingLabel: "Thực chi",
                      trailingLabel: "Dự kiến",
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: ["Sắp tới", "Đã chi", "Muộn"]
                    .asMap()
                    .map<int, Widget>((key, value) => MapEntry(
                        key,
                        ChoiceChip(
                          label: Text(value, style: TextStyle(color: key == _currentTab ? Colors.white : Colors.black)),
                          selected: key == _currentTab,
                          onSelected: (val) {
                            setState(() {
                              _currentTab = key;
                            });
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.pink.shade50,
                        )))
                    .values
                    .toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              // Column(
              //   children: _getTransactionToDisplay(expenses.toList()).map((transact) {
              //     return PlanTransactionCard(planTransaction: transact);
              //   }).toList(),
              // ),
            ],
          );
  }
}
