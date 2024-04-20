import 'package:flutter/material.dart';

class SummaryInfoTable extends StatelessWidget {
  const SummaryInfoTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTable(
        showCheckboxColumn: false,
        columnSpacing: 40,
        headingRowHeight: 20,
        dataRowMaxHeight: 30,
        dataRowMinHeight: 20,
        columns: [
          DataColumn(
            label: Text(""),
          ),
          DataColumn(
            numeric: true,
            label: Text("Dự kiến"),
          ),
          DataColumn(
            numeric: true,
            label: Text("Thực tế"),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(Text("Thu nhập")),
              DataCell(Text("12000000")),
              DataCell(Text("12000000")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Chi phí")),
              DataCell(Text("7000000")),
              DataCell(Text("8000000")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Tiết kiệm")),
              DataCell(Text("2400000")),
              DataCell(Text("2000000")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Khoản nợ")),
              DataCell(Text("2000000")),
              DataCell(Text("2000000")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Tăng trưởng")),
              DataCell(Text("5000000")),
              DataCell(Text("5200000")),
            ],
          ),
        ],
      ),
    );
  }

  _buildRow(String title, List<Widget> content, {List<Widget>? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ] +
                (subtitle ?? []),
          ),
        ),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
        ),
      ],
    );
  }
}
