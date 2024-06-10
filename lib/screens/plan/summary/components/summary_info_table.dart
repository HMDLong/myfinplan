import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/plan/summary/providers/summary_data_provider.dart';
import 'package:myfinplan/utils/format.dart';

class SummaryInfoTable extends StatelessWidget {
  const SummaryInfoTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(summaryDataProvider).when(
              data: (data) {
                return DataTable(
                  showCheckboxColumn: false,
                  columnSpacing: 25,
                  headingRowHeight: 20,
                  dataRowMaxHeight: 30,
                  dataRowMinHeight: 20,
                  horizontalMargin: 10,
                  dataTextStyle: const TextStyle(fontSize: 12, color: Colors.black),
                  columns: const [
                    DataColumn(label: Text("")),
                    DataColumn(numeric: true, label: Text("Dự kiến")),
                    DataColumn(numeric: true, label: Text("Thực tế")),
                    DataColumn(numeric: true, label: Text("Chênh lệch")),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text("Thu nhập")),
                        DataCell(Text(Formatter.amountToDecimal(data[0], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[1], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[1] - data[0], currency: null))),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Chi phí")),
                        DataCell(Text(Formatter.amountToDecimal(data[2], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[3], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[3] - data[2], currency: null))),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Tiết kiệm")),
                        DataCell(Text(Formatter.amountToDecimal(data[4], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[5], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[5] - data[4], currency: null))),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Trả nợ")),
                        DataCell(Text(Formatter.amountToDecimal(data[6], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[7], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[7] - data[6], currency: null))),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text("Tăng trưởng")),
                        DataCell(Text(Formatter.amountToDecimal(data[0], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[1], currency: null))),
                        DataCell(Text(Formatter.amountToDecimal(data[1] - data[0], currency: null))),
                      ],
                    ),
                  ],
                );
              },
              error: (error, _) => Text("$error"),
              loading: () => const CircularProgressIndicator(),
            );
      },
    );
  }
}
