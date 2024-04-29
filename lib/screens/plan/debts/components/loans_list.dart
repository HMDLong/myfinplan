import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/plan/debt_strat.dart';
import 'package:myfinplan/screens/plan/debts/debt_tab.dart';
import 'package:myfinplan/screens/plan/plan_screen.dart';
import 'package:myfinplan/utils/format.dart';

class LoansList extends ConsumerStatefulWidget {
  final DebtsInfoModel data;
  const LoansList({super.key, required this.data});

  @override
  ConsumerState<LoansList> createState() => _LoansListState();
}

final loansByStrategyProvider = FutureProvider((ref) async {
  final debtStrategy = ref.watch(currentDebtStratProvider);
  final currentTime = ref.watch(planTimeRangeProvider);
  final loans = (await ref.watch(accountsProvider).getAccountByType(AccountType.debt)).cast<Debt>();
});

class _LoansListState extends ConsumerState<LoansList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, i) {
        final debt = widget.data.accounts[i];
        final paid = widget.data.paidAmounts[i];
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
            leading: Text("${i + 1}"),
            trailing: Text("${amountToCompact(paid, currency: null)}/${amountToCompact(debt.amount!, currency: null)}"),
          ),
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: 10),
      itemCount: widget.data.accounts.length,
    );
  }
}
