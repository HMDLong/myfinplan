import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/utils/format.dart';

class AccountSummarySection extends ConsumerStatefulWidget {
  const AccountSummarySection({
    super.key,
  });

  @override
  ConsumerState<AccountSummarySection> createState() => _AccountSummarySectionState();
}

class _AccountSummarySectionState extends ConsumerState<AccountSummarySection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        children: const [
          AccountTile(
            amount: 10000000,
            label: 'Tiền mặt',
            icon: Icon(Boxicons.bx_money),
            color: CupertinoColors.activeGreen,
          ),
          AccountTile(
            amount: 10000000,
            label: 'Tiền mặt',
            icon: Icon(Boxicons.bx_money),
            color: CupertinoColors.activeBlue,
          ),
          AccountTile(
            amount: 10000000,
            label: 'Tiền mặt',
            icon: Icon(Boxicons.bx_money),
            color: CupertinoColors.activeOrange,
          ),
          AccountTile(
            amount: 10000000,
            label: 'Tiền mặt',
            icon: Icon(Boxicons.bx_money),
            color: CupertinoColors.systemPurple,
          ),
        ],
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String label;
  final Icon icon;
  final int amount;
  final Color color;
  const AccountTile({
    super.key,
    required this.amount,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: icon,
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    amountToDecimal(amount),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
