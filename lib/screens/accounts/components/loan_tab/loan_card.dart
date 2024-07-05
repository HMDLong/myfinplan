import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/screens/accounts/widgets/account_card.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class LoanCard extends ConsumerWidget {
  final Loan account;
  final void Function()? onDelete;
  const LoanCard({
    super.key,
    required this.account,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountCard(
      gradient: LinearGradient(
        colors: [
          Colors.green.shade400,
          Colors.green.shade800,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: account.title,
      onEdit: () {
        pushNewScreen(
          context,
          screen: AddOrEditAccountScreen(
            initType: AccountType.loan,
            prefill: account,
          ),
        );
      },
      onDelete: () {
        if (onDelete != null) {
          onDelete!();
        }
        ref.read(accountsProvider.notifier).deleteAccount(account.id);
      },
      children: [
        // AccountCardSection(
        //   label: "Kỳ hạn",
        //   value: amountToDecimal(account.payment),
        //   bottom: 10.0,
        //   start: 10.0,
        //   labelColor: Colors.green.shade50,
        //   leftAligned: false,
        // ),
        AccountCardSection(
          label: "Số dư",
          value: Formatter.amountToDecimal(account.amount),
          bottom: 10.0,
          start: 10.0,
          direction: TextDirection.rtl,
          labelColor: Colors.green.shade50,
          leftAligned: false,
        ),
      ],
    );
  }
}
