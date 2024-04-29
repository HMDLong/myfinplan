import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/widgets/account_card.dart';
import 'package:myfinplan/utils/format.dart';

class CreditCard extends ConsumerStatefulWidget {
  final Credit account;
  final void Function()? onDelete;
  final void Function()? onEdit;
  const CreditCard({
    super.key,
    required this.account,
    this.onDelete,
    this.onEdit,
  });

  @override
  ConsumerState<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends ConsumerState<CreditCard> {
  @override
  Widget build(BuildContext context) {
    return AccountCard(
      gradient: LinearGradient(
        colors: [
          Colors.pink.shade400,
          Colors.pink.shade800,
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
        Positioned.directional(
          textDirection: TextDirection.rtl,
          bottom: 10.0,
          start: 10.0,
          child: Text(
            amountToDecimal(widget.account.amount!),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
