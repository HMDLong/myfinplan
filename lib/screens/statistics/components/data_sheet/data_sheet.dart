import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/utils/time/times.dart';

class DataTab extends ConsumerStatefulWidget {
  const DataTab({super.key});

  @override
  ConsumerState<DataTab> createState() => _DataTabState();
}

class _DataTabState extends ConsumerState<DataTab> {
  @override
  Widget build(BuildContext context) {
    final range = getRangeOfTheMonth();
    final incomes = 100000; //ref.watch(totalActualIncomeProvider(range));
    final expenses = 10000; //ref.watch(totalActualExpenseProvider(range));
    final currencyFormat = NumberFormat.decimalPattern();
    return ListView(
      children: [
        Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Dòng tiền", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                DataTable(
                    dataTextStyle: const TextStyle(fontSize: 12, color: Colors.black),
                    headingRowHeight: 30,
                    // headingRowColor: MaterialStateColor.resolveWith((_) => Colors.blue.shade400),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columnSpacing: 25,
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text("Mục")),
                      DataColumn(label: Text("Thu nhập")),
                      DataColumn(label: Text("Chi phí")),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text("Tổng")),
                        DataCell(Text(currencyFormat.format(incomes))),
                        DataCell(Text(currencyFormat.format(expenses))),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text("Trung bình ngày")),
                        DataCell(Text(currencyFormat.format(incomes ~/ range.duration))),
                        DataCell(Text(currencyFormat.format(expenses ~/ range.duration))),
                      ]),
                      const DataRow(cells: [
                        DataCell(Text("Cao nhất ngày")),
                        DataCell(Text("100000")),
                        DataCell(Text("100000")),
                      ]),
                      const DataRow(cells: [
                        DataCell(Text("Thấp nhất ngày")),
                        DataCell(Text("100000")),
                        DataCell(Text("100000")),
                      ]),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                const Align(alignment: Alignment.centerRight, child: Text("Dòng tiền: 100000 VND")),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Chi tiết thu chi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Divider(),
                DataTable(
                    headingRowHeight: 30,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: [
                      const DataColumn(label: Text("Thu nhập")),
                      DataColumn(label: Text(currencyFormat.format(incomes))),
                      const DataColumn(label: Text("100%")),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text("")),
                        DataCell(Text("0")),
                        DataCell(Text("---")),
                      ])
                    ]),
                const SizedBox(
                  height: 10,
                ),
                DataTable(
                    headingRowHeight: 30,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: [
                      const DataColumn(label: Text("Chi phí")),
                      DataColumn(label: Text(currencyFormat.format(expenses))),
                      const DataColumn(label: Text("100%")),
                    ],
                    rows: const [
                      DataRow(cells: [
                        DataCell(Text("")),
                        DataCell(Text("0")),
                        DataCell(Text("---")),
                      ])
                    ])
              ],
            ),
          ),
        ),
      ],
    );
  }
}
