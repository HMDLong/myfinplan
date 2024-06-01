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
  _info(String label, String value, {Color? labelColor, bool alignLeft = true}) {
    return Column(
      crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor ?? Colors.white,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

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
        AccountCardSection(
          label: "Số dư tín dụng",
          value: amountToDecimal(widget.account.amount!),
          bottom: 10.0,
          start: 10.0,
          direction: TextDirection.rtl,
          labelColor: Colors.pink.shade50,
          leftAligned: false,
        ),
        AccountCardSection(
          label: "Hạn mức tín dụng",
          value: amountToDecimal(widget.account.limit),
          bottom: 60.0,
          start: 10.0,
          labelColor: Colors.pink.shade50,
        ),
        AccountCardSection(
          label: "Lãi suất",
          value: "${18.99} %",
          bottom: 60.0,
          start: 10.0,
          direction: TextDirection.rtl,
          labelColor: Colors.pink.shade50,
          leftAligned: false,
        ),
      ],
    );
  }
}
