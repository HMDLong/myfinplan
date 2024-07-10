import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/styles.dart';

class AccountSummarySection extends ConsumerStatefulWidget {
  const AccountSummarySection({
    super.key,
  });

  @override
  ConsumerState<AccountSummarySection> createState() => _AccountSummarySectionState();
}

final balanceSummaryProvider = FutureProvider((ref) async {
  final accounts = await ref.watch(accountsProvider).getAllAccount();
  final res = accounts.fold(<AccountType, int>{}, (prev, acc) {
    prev[acc.accountType] = (prev[acc.accountType] ?? 0) + acc.usableBalance;
    return prev;
  });
  return res;
});

class _AccountSummarySectionState extends ConsumerState<AccountSummarySection> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(balanceSummaryProvider).when(
      data: (data) {
        return SizedBox(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            children: [
              AccountTile(
                amount: data[AccountType.cash] ?? 0,
                label: 'Tiền mặt',
                icon: const Icon(Boxicons.bx_dollar),
                color: CupertinoColors.activeGreen,
              ),
              AccountTile(
                amount: data[AccountType.debit] ?? 0,
                label: 'Ví',
                icon: const Icon(Boxicons.bx_wallet),
                color: CupertinoColors.activeBlue,
              ),
              AccountTile(
                amount: data[AccountType.credit] ?? 0,
                label: 'Tín dụng',
                icon: const Icon(Boxicons.bx_credit_card),
                color: CupertinoColors.activeOrange,
              ),
              AccountTile(
                amount: data[AccountType.saving] ?? 0,
                label: 'Tiết kiệm',
                icon: const Icon(Boxicons.bx_coin_stack),
                color: CupertinoColors.systemPurple,
              ),
            ],
          ),
        );
      },
      error: (error, _) {
        return SizedBox(
          height: 200,
          width: double.infinity,
          child: Column(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_rounded)),
              const Text("Đã có lỗi xảy ra"),
            ],
          ),
        );
      },
      loading: () {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return StyleRes.shimmerGradient().createShader(bounds);
          },
          child: const SizedBox(
            height: 200,
            width: double.infinity,
          ),
        );
      },
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
              backgroundColor: Colors.transparent,
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
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    Formatter.amountToDecimal(amount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
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
