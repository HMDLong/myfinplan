import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/components/cash_tab/cash_card.dart';
import 'package:myfinplan/screens/accounts/components/loan_tab/loan_card.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart.dart';
import 'package:myfinplan/shared_widgets/transaction_list/transaction_list.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/time/times.dart';

class LoanTab extends ConsumerStatefulWidget {
  const LoanTab({super.key});

  @override
  ConsumerState<LoanTab> createState() => _LoanTabState();
}

enum LoanContentTab {
  graph,
  transacts,
  // stats,
}

final loansProvider = FutureProvider((ref) async {
  final loans = (await ref.watch(accountsProvider).getAccountByType(AccountType.loan)).cast<Loan>();
  return loans;
});

class _LoanTabState extends ConsumerState<LoanTab> {
  final menuItems = [
    const DropdownMenuEntry(value: LoanContentTab.graph, label: "Biến động số dư"),
    const DropdownMenuEntry(value: LoanContentTab.transacts, label: "Giao dịch liên quan"),
    // const DropdownMenuEntry(value: LoanContentTab.stats, label: "Số liệu"),
  ];

  LoanContentTab _currentContent = LoanContentTab.graph;
  int _currentAccIndex = 0;

  _buildContent(Loan account) {
    return switch (_currentContent) {
      LoanContentTab.graph => SingleChildScrollView(
          child: BalanceChart<Loan>(
            chartHeight: 240,
            account: account,
            timeRange: TimeRange.lastNDays(30),
          ),
        ),
      LoanContentTab.transacts => TransactionList(
          account: account,
        ),
      // LoanContentTab.stats => const Column(
      //     children: [
      //       Text("transact"),
      //     ],
      //   ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(loansProvider).when(
          data: (accounts) {
            return Column(
              children: [
                const SizedBox(height: 10),
                CarouselSlider.builder(
                  itemCount: accounts.length,
                  itemBuilder: (ctx, index, i) {
                    final account = accounts[index];
                    return LoanCard(account: account);
                  },
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    aspectRatio: 2.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentAccIndex = index;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: menuItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InputChip(
                          showCheckmark: false,
                          backgroundColor: Colors.blue.shade100,
                          selectedColor: CupertinoColors.activeBlue,
                          selected: _currentContent == item.value,
                          label: Text(
                            item.label,
                            style: TextStyle(
                              color: _currentContent == item.value ? Colors.white : CupertinoColors.activeBlue,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentContent = item.value;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildContent(accounts[_currentAccIndex])),
              ],
            );
          },
          error: (error, _) {
            return SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text(widgetRefreshLabel),
                  ),
                  const SizedBox(height: 10),
                  const Text(widgetErrorMessage),
                ],
              ),
            );
          },
          loading: () => const SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
