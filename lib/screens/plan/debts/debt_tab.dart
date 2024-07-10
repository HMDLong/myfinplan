import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
import 'package:myfinplan/screens/plan/debts/components/strat_picker.dart';
import 'package:myfinplan/screens/plan/debts/widgets/detail_loan.dart';
import 'package:myfinplan/screens/plan/debts/widgets/schedule_table.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/goals_section.dart';
import 'package:myfinplan/utils/strings.dart';
import 'package:myfinplan/utils/format.dart';

class DebtManageTab extends ConsumerStatefulWidget {
  const DebtManageTab({super.key});

  @override
  ConsumerState<DebtManageTab> createState() => _DebtManageTabState();
}

const double heightPerCell = 40;
const double widgetPerCell = 80;
const double paddinHeigth = 15;
const double headerHeight = 24;
const double loanHeaderWidth = 60;

const dataStyle = TextStyle(
  fontSize: 12,
);

class _DebtManageTabState extends ConsumerState<DebtManageTab> {
  Widget _emptyLoanView() {
    return const SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(StringRes.noItemsMessage),
        ],
      ),
    );
  }

  Widget _cell(
    String text, {
    Color color = Colors.white,
    double height = heightPerCell,
    double width = widgetPerCell,
    bool isSelected = false,
    bool rightAlign = true,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints.expand(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          color: color,
          border: isSelected
              ? Border.all(
                  width: 1.0,
                  color: CupertinoColors.activeBlue,
                )
              : null,
        ),
        margin: const EdgeInsets.all(2.0),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: rightAlign ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              text,
              style: dataStyle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(loansInfoProvider).when(
            data: (info) {
              if (info.loans.isEmpty) {
                return _emptyLoanView();
              }
              final months = info.schedule.keys.toList()..sort((a, b) => a.compareTo(b));
              return Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final selectedContent = ref.watch(loanSelectedContentProvider);
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Tổng dư nợ"),
                                    Text(Formatter.amountToDecimal(info.totalBalance.toInt())),
                                  ],
                                ),
                              ),
                              const Expanded(child: StrategyPickerBox()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Lịch trình (${Formatter.toVnMonthYear(months.first)} ~ ${Formatter.toVnMonthYear(months.last)})",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          LoanScheduleTable(info: info, selectedContent: selectedContent),
                          const SizedBox(height: 10),
                          const Text(
                            "Chi tiết lịch trình",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          switch (selectedContent.content) {
                            ContentType.month => _buildMonthDetail(info, selectedContent),
                            ContentType.loan => DetailLoanSection(info: info, state: selectedContent),
                          },
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, _) {
              log(error.toString());
              return SizedBox.expand(
                child: Text("$error"),
              );
            },
            loading: () => const SizedBox.expand(
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
    );
  }

  _buildMonthDetail(LoanInfo info, SelectedContentState state) {
    final scheduleData = info.schedule[state.month];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 30,
        horizontalMargin: 6,
        dataRowMaxHeight: 30,
        dataRowMinHeight: 20,
        columnSpacing: 32,
        dataTextStyle: dataTextStyle,
        columns: [
          const DataColumn(label: Text("")),
          ...info.loans.map(
            (e) => DataColumn(
              label: Text(e.title),
              numeric: true,
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text("Gốc")),
              ...info.loans.map((e) {
                final data = scheduleData?[e.id];
                return DataCell(
                  Text(Formatter.amountToDecimal(data!.principal.round(), currency: null)),
                );
              }),
            ],
          ),
          DataRow(
            selected: true,
            cells: [
              const DataCell(Text("Lãi")),
              ...info.loans.map((e) {
                final data = scheduleData?[e.id];
                return DataCell(
                  Text(Formatter.amountToDecimal(data!.interest.round(), currency: null)),
                );
              }),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text("Cầu tuyết")),
              ...info.loans.map((e) {
                final data = scheduleData?[e.id];
                return DataCell(
                  Text(Formatter.amountToDecimal(data!.snowball.round(), currency: null)),
                );
              }),
            ],
          ),
          DataRow(
            selected: true,
            cells: [
              const DataCell(Text("Tổng trả")),
              ...info.loans.map((e) {
                final data = scheduleData?[e.id];
                return DataCell(
                  Text(
                    Formatter.amountToDecimal(data!.totalPayment.round(), currency: null),
                  ),
                );
              }),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text("Đã trả")),
              ...info.paysThisMonth.map((e) => DataCell(
                    Text(Formatter.amountToDecimal(e.round(), currency: null)),
                  )),
            ],
          ),
          DataRow(
            selected: true,
            cells: [
              const DataCell(Text("Dư nợ")),
              ...info.loans.map((e) {
                final data = scheduleData?[e.id];
                return DataCell(
                  Text(Formatter.amountToDecimal(data!.remainingBalance.round(), currency: null)),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
