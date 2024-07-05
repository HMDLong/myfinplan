import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/screens/accounts/widgets/account_card.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DebitCard extends ConsumerStatefulWidget {
  final Debit account;
  final void Function()? onDelete;
  final void Function()? onEdit;
  const DebitCard({
    super.key,
    required this.account,
    this.onDelete,
    this.onEdit,
  });

  @override
  ConsumerState<DebitCard> createState() => _DebitCardState();
}

class _DebitCardState extends ConsumerState<DebitCard> {
  @override
  Widget build(BuildContext context) {
    return AccountCard(
      gradient: const LinearGradient(
        colors: [
          Colors.blue,
          CupertinoColors.activeBlue,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: widget.account.title,
      onEdit: () {
        pushNewScreen(
          context,
          screen: AddOrEditAccountScreen(
            initType: AccountType.debit,
            prefill: widget.account,
          ),
        );
      },
      onDelete: () {
        if (widget.onDelete != null) {
          widget.onDelete!();
        }
        ref.read(accountsProvider.notifier).deleteAccount(widget.account.id);
      },
      children: [
        AccountCardSection(
          label: "Số dư",
          value: Formatter.amountToDecimal(widget.account.amount!),
          bottom: 10.0,
          start: 10.0,
          direction: TextDirection.rtl,
          labelColor: Colors.blue.shade50,
          leftAligned: false,
        ),
      ],
    );
  }
}
