import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/styles.dart';

class DetailLoanSection extends StatelessWidget {
  final LoanInfo info;
  final SelectedContentState state;
  const DetailLoanSection({
    super.key,
    required this.info,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final data = info.schedule.map((key, value) {
      return MapEntry(key, value[state.loanId]);
    });
    final months = data.keys.toList()..sort((a, b) => a.compareTo(b));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 30,
        horizontalMargin: 6,
        dataRowMaxHeight: 30,
        dataRowMinHeight: 20,
        columnSpacing: 32,
        dataTextStyle: StyleRes.dataTextStyle,
        columns: const [
          DataColumn(label: Text("")),
          DataColumn(label: Text("Tổng trả"), numeric: true),
          DataColumn(label: Text("Gốc"), numeric: true),
          DataColumn(label: Text("Lãi"), numeric: true),
          DataColumn(label: Text("Cầu tuyết"), numeric: true),
          DataColumn(label: Text("Dư nợ"), numeric: true),
        ],
        rows: months.map((e) {
          final monthData = data[e];
          return DataRow(
            cells: [
              DataCell(Text("${e.month}/${e.year}")),
              DataCell(
                Text(
                  Formatter.amountToDecimal(
                    monthData!.totalPayment.round(),
                    currency: null,
                  ),
                ),
              ),
              DataCell(
                Text(Formatter.amountToDecimal(monthData.principal.round(), currency: null)),
              ),
              DataCell(
                Text(Formatter.amountToDecimal(monthData.interest.round(), currency: null)),
              ),
              DataCell(
                Text(Formatter.amountToDecimal(monthData.snowball.round(), currency: null)),
              ),
              DataCell(
                Text(Formatter.amountToDecimal(monthData.remainingBalance.round(), currency: null)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
