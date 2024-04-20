import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/presentation/accounts/components/cash_tab/cash_card.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart/balance_chart.dart';
import 'package:myfinplan/shared_widgets/transaction_list/transaction_list.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/time/times.dart';

class CashTab extends ConsumerStatefulWidget {
  const CashTab({super.key});

  @override
  ConsumerState<CashTab> createState() => _CashTabState();
}

enum CashContentTab {
  graph,
  transacts,
  stats,
}

final getCashAccountsDetail = FutureProvider((ref) async {
  final cashes = (await ref.watch(accountsProvider).getAccountByType(AccountType.cash)).cast<Cash>();
  return cashes;
});

class _CashTabState extends ConsumerState<CashTab> {
  final menuItems = [
    const DropdownMenuEntry(value: CashContentTab.graph, label: "Biến động số dư"),
    const DropdownMenuEntry(value: CashContentTab.transacts, label: "Giao dịch liên quan"),
    const DropdownMenuEntry(value: CashContentTab.stats, label: "Số liệu"),
  ];

  CashContentTab _currentContent = CashContentTab.graph;
  int _currentAccIndex = 0;

  _buildContent(Cash account) {
    return switch (_currentContent) {
      CashContentTab.graph => SingleChildScrollView(
          child: BalanceChart<Cash>(
            chartHeight: 240,
            account: account,
            timeRange: TimeRange.lastNDays(30),
          ),
        ),
      CashContentTab.transacts => TransactionList(
          account: account,
        ),
      CashContentTab.stats => const Column(
          children: [
            Text("transact"),
          ],
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCashAccountsDetail).when(
          data: (accounts) {
            return Column(
              children: [
                const SizedBox(height: 10),
                CarouselSlider.builder(
                  itemCount: accounts.length,
                  itemBuilder: (ctx, index, i) {
                    final account = accounts[index];
                    return CashCard(account: account);
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
                Expanded(
                  child: _buildContent(accounts[_currentAccIndex]),
                ),
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
