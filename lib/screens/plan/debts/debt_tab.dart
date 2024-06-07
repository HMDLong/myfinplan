import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/amortizing_info.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/screens/plan/debts/components/provider/providers.dart';
import 'package:myfinplan/screens/plan/debts/components/strat_picker.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/recap_screen_components/goals_section.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

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
          Text(noItemsMessage),
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
                                    const Text("Tổng số dư"),
                                    Text(amountToDecimal(info.totalBalance.toInt())),
                                  ],
                                ),
                              ),
                              const Expanded(child: StrategyPickerBox()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Lịch trình (${toVnMonthYear(months.first)} ~ ${toVnMonthYear(months.last)})",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: heightPerCell * (info.loans.length + 1) + 8 * 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [_cell("", height: headerHeight, width: loanHeaderWidth)] +
                                      info.loans
                                          .map(
                                            (e) => _cell(
                                              e.title,
                                              color: Colors.blue.shade200,
                                              width: loanHeaderWidth,
                                              isSelected: selectedContent.content == ContentType.loan && selectedContent.loanId == e.id,
                                              onTap: () {
                                                if (selectedContent.loanId == e.id) {
                                                  ref.read(loanSelectedContentProvider.notifier).state = SelectedContentState.init();
                                                } else {
                                                  ref.read(loanSelectedContentProvider.notifier).state = selectedContent.copyWith(
                                                    content: ContentType.loan,
                                                    loanId: e.id,
                                                    month: null,
                                                  );
                                                }
                                              },
                                            ),
                                          )
                                          .toList(),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      final month = months[index];
                                      return Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: widgetPerCell,
                                        ),
                                        child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            if (i == 0) {
                                              return _cell(
                                                "${month.month}/${month.year}",
                                                color: Colors.blue.shade200,
                                                height: headerHeight,
                                                isSelected: selectedContent.content == ContentType.month && selectedContent.month!.isAtSameMomentAs(month),
                                                onTap: () {
                                                  if (selectedContent.month == month) {
                                                    ref.read(loanSelectedContentProvider.notifier).state = SelectedContentState.init();
                                                  } else {
                                                    ref.read(loanSelectedContentProvider.notifier).state = selectedContent.copyWith(
                                                      content: ContentType.month,
                                                      month: month,
                                                      loanId: null,
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                            final entry = info.schedule[month]?[info.loans[i - 1].id];
                                            return _cell(
                                              amountToDecimal(entry!.totalPayment.round(), currency: null),
                                              color: i.remainder(2) == 0 ? Colors.grey.shade300 : Colors.white,
                                            );
                                          },
                                          itemCount: info.loans.length + 1,
                                        ),
                                      );
                                    },
                                    itemCount: months.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            ContentType.loan => _buildLoanDetail(info, selectedContent),
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
      // floatingActionButton: FloatingActionButton(
      //   heroTag: "add_loan_fab",
      //   onPressed: () {
      //     pushNewScreen(
      //       context,
      //       screen: const AddOrEditAccountScreen(initType: AccountType.loan),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
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
                  Text(amountToDecimal(data!.principal.round(), currency: null)),
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
                  Text(amountToDecimal(data!.interest.round(), currency: null)),
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
                  Text(amountToDecimal(data!.snowball.round(), currency: null)),
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
                    amountToDecimal(data!.totalPayment.round(), currency: null),
                  ),
                );
              }),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text("Đã trả")),
              ...info.paysThisMonth.map((e) => DataCell(
                    Text(amountToDecimal(e.round(), currency: null)),
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
                  Text(amountToDecimal(data!.remainingBalance.round(), currency: null)),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  _buildLoanDetail(LoanInfo info, SelectedContentState state) {
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
        dataTextStyle: dataTextStyle,
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
                  amountToDecimal(
                    monthData!.totalPayment.round(),
                    currency: null,
                  ),
                ),
              ),
              DataCell(
                Text(amountToDecimal(monthData.principal.round(), currency: null)),
              ),
              DataCell(
                Text(amountToDecimal(monthData.interest.round(), currency: null)),
              ),
              DataCell(
                Text(amountToDecimal(monthData.snowball.round(), currency: null)),
              ),
              DataCell(
                Text(amountToDecimal(monthData.remainingBalance.round(), currency: null)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
