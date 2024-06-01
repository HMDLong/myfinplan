import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/widgets/account_card.dart';
import 'package:myfinplan/utils/format.dart';

class SavingCard extends ConsumerStatefulWidget {
  final Saving account;
  final void Function()? onDelete;
  final void Function()? onEdit;
  const SavingCard({
    super.key,
    required this.account,
    this.onDelete,
    this.onEdit,
  });

  @override
  ConsumerState<SavingCard> createState() => _SavingCardState();
}

class _SavingCardState extends ConsumerState<SavingCard> {
  @override
  Widget build(BuildContext context) {
    return AccountCard(
      gradient: LinearGradient(
        colors: [
          Colors.purple.shade400,
          Colors.purple.shade800,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: widget.account.title!,
      onDelete: () {
        if (widget.onDelete != null) {
          widget.onDelete!();
        }
        ref.read(accountsProvider.notifier).deleteAccount(widget.account.id!);
      },
      children: [
        AccountCardSection(
          label: "Số dư",
          value: amountToDecimal(widget.account.amount!),
          bottom: 10.0,
          start: 10.0,
          direction: TextDirection.rtl,
          labelColor: Colors.purple.shade50,
          leftAligned: false,
        )
      ],
    );
  }
}
