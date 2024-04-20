import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/presentation/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/presentation/plan/plan_screen.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DebtManageTab extends ConsumerStatefulWidget {
  const DebtManageTab({super.key});

  @override
  ConsumerState<DebtManageTab> createState() => _DebtManageTabState();
}

class DebtsInfoModel {
  List<Debt> accounts;
  List<int> paidAmounts;

  DebtsInfoModel({
    List<Debt>? debts,
    List<int>? paids,
  })  : accounts = debts ?? [],
        paidAmounts = paids ?? [];
}

final getDebtsDetail = FutureProvider((ref) async {
  final debts = (await ref.watch(accountsProvider).getAccountByType(AccountType.debt)).cast<Debt>();
  final thisTime = ref.watch(planTimeRangeProvider);
  final info = DebtsInfoModel();
  for (var debt in debts) {
    final paidAmount = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.transact)).where((e) {
      return e.targetAccountId == debt.id && e.paid && thisTime.contain(e.timestamp);
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
                LinearProgressGauge(
                  value: totalPaidThisRange,
                  max: totalDebt.abs() ~/ 10,
                  mode: GaugeMode.goodOverflow,
                  leadingLabel: "Đã trả",
                  trailingLabel: "Dự kiến",
                ),
                const SizedBox(height: 10),
                const ListTile(
                  minLeadingWidth: 12,
                  dense: true,
                  leading: Text(""),
                  title: Text("Tài khoản"),
                  trailing: Text("Thực tế/ Dự kiến (tháng)"),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: info.accounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final debt = info.accounts[index];
                    final paid = info.paidAmounts[index];
                    return GestureDetector(
                      onTap: () {
                        // pushNewScreen(context, screen: screen);
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: Colors.blue.shade50,
                        key: Key(debt.id!),
                        dense: true,
                        minLeadingWidth: 12,
                        title: Text(debt.title!),
                        subtitle: Text(amountToDecimal(debt.amount!)),
                        leading: Text("${index + 1}"),
                        trailing: Text("${amountToCompact(paid, currency: null)}/${amountToCompact(debt.amount!, currency: null)}"),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(
                    height: 6,
                  ),
                ),
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
