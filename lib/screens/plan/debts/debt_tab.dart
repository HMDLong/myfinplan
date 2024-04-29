import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/plan/debt_strat.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/screens/plan/debts/components/loans_list.dart';
import 'package:myfinplan/screens/plan/debts/widgets/strat_picker_bottom_sheet.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DebtManageTab extends ConsumerStatefulWidget {
  const DebtManageTab({super.key});

  @override
  ConsumerState<DebtManageTab> createState() => _DebtManageTabState();
}

class DebtsInfoModel with EquatableMixin {
  List<Debt> accounts;
  List<int> paidAmounts;
  int boostIdx;
  int boostAmount;

  DebtsInfoModel({
    List<Debt>? debts,
    List<int>? paids,
    int? boostIndex,
    int? boostAmount,
  })  : accounts = debts ?? [],
        paidAmounts = paids ?? [],
        boostIdx = boostIndex ?? -1,
        boostAmount = boostAmount ?? 0;

  @override
  List<Object?> get props => [accounts, paidAmounts, boostIdx, boostAmount];
}

final getDebtsDetail = FutureProvider((ref) async {
  final debts = (await ref.watch(accountsProvider).getAccountByType(AccountType.debt)).cast<Debt>();
  final thisTime = ref.watch(planTimeRangeProvider);
  final info = DebtsInfoModel();
  for (var debt in debts) {
    final paidAmount = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.transact)).where((e) {
      return e.toAccId == debt.id && e.paid && thisTime.contain(e.timestamp);
    }).fold(0, (prev, e) {
      return prev + e.amount;
    });
    info.accounts.add(debt);
    info.paidAmounts.add(paidAmount);
  }
  return info;
});

class _DebtManageTabState extends ConsumerState<DebtManageTab> {
  @override
  Widget build(BuildContext context) {
    final info = ref.watch(getDebtsDetail).when(
          data: (data) => data,
          error: (error, _) {
            log(error.toString());
            return DebtsInfoModel();
          },
          loading: () => DebtsInfoModel(),
        );
    final totalDebt = info.accounts.fold(0, (prev, e) {
      return prev + e.amount!;
    });
    final totalPaidThisRange = info.paidAmounts.fold(0, (prev, e) {
      return prev + e.abs();
    });
    return Scaffold(
      body: info.accounts.isEmpty
          ? const SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(noItemsMessage),
                ],
              ),
            )
          : ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                const Text(
                  "Tổng số nợ",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  amountToDecimal(totalDebt),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tình trạng nợ",
                            style: TextStyle(fontSize: 12),
                          ),
                          InputChip(
                            backgroundColor: Colors.red.shade100,
                            label: const Text(
                              "Nợ xấu",
                              style: TextStyle(color: Colors.red),
                            ),
                            avatar: const Icon(
                              Icons.thumb_down_alt_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chiến lược quản lý",
                            style: TextStyle(fontSize: 12),
                          ),
                          InputChip(
                            label: Consumer(
                              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                final currentStrat = ref.watch(currentDebtStratProvider);
                                return Text(currentStrat.title);
                              },
                            ),
                            avatar: const Icon(
                              Icons.swap_horiz_rounded,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.white,
                            side: const BorderSide(width: 0.5),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return const StrategyPickerBottomSheet();
                                },
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressGauge(
                  value: totalPaidThisRange,
                  max: totalDebt.abs() ~/ 10,
                  mode: GaugeMode.goodOverflow,
                  showOverflow: true,
                  leadingLabel: "Đã trả",
                  trailingLabel: "Dự kiến",
                ),
                const SizedBox(height: 10),
                const ListTile(
                  minLeadingWidth: 12,
                  dense: true,
                  titleTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                  leadingAndTrailingTextStyle: TextStyle(fontSize: 12, color: Colors.black),
                  leading: Text(""),
                  title: Text("Tài khoản"),
                  trailing: Text("Thực tế/ Dự kiến (tháng)"),
                ),
                LoansList(data: info),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(
            context,
            screen: const AddOrEditAccountScreen(initType: AccountType.debt),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
