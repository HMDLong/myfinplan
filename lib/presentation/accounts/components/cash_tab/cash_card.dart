import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/presentation/accounts/widgets/account_card.dart';
import 'package:myfinplan/utils/format.dart';

class CashCard extends StatefulWidget {
  final Cash account;
  const CashCard({super.key, required this.account});

  @override
  State<CashCard> createState() => _CashCardState();
}

class _CashCardState extends State<CashCard> {
  @override
  Widget build(BuildContext context) {
    return AccountCard(
      gradient: LinearGradient(
        colors: [
          Colors.green.shade400,
          Colors.green.shade800,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: widget.account.title!,
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
