import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/components/credit_tab/credit_card.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart.dart';
import 'package:myfinplan/shared_widgets/transaction_list/transaction_list.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/time/times.dart';

class CreditTab extends StatefulWidget {
  const CreditTab({super.key});

  @override
  State<CreditTab> createState() => _CreditTabState();
}

enum CreditContentTab {
  graph,
  transacts,
  debt,
  // stats,
}

final getCreditAccountsDetail = FutureProvider((ref) async {
  final credits = (await ref.watch(accountsProvider).getAccountByType(AccountType.credit)).cast<Credit>();
  return credits;
});

class _CreditTabState extends State<CreditTab> {
  final menuItems = [
    const DropdownMenuEntry(value: CreditContentTab.graph, label: "Biến động số dư"),
    const DropdownMenuEntry(value: CreditContentTab.transacts, label: "Giao dịch liên quan"),
    // const DropdownMenuEntry(value: CreditContentTab.stats, label: "Số liệu"),
    const DropdownMenuEntry(value: CreditContentTab.debt, label: "Số liệu"),
  ];

  CreditContentTab _currentContent = CreditContentTab.graph;
  int _currentAccIndex = 0;

  _buildContent(Credit account) {
    return switch (_currentContent) {
      CreditContentTab.graph => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text("Hiển thị biến động trong 30 ngày vừa qua"),
              ),
              const SizedBox(height: 10),
              BalanceChart<Credit>(
                chartHeight: 240,
                account: account,
                timeRange: TimeRange.lastNDays(30),
              ),
            ],
          ),
        ),
      CreditContentTab.transacts => TransactionList(
          account: account,
        ),
      // CreditContentTab.stats => const Column(
      //     children: [
      //       Text("transact"),
      //     ],
      //   ),
      CreditContentTab.debt => const Column(
          children: [],
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ref.watch(getCreditAccountsDetail).when(
              data: (accounts) {
                return accounts.isEmpty
                    ? const SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Không có dữ liệu"),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 10),
                          CarouselSlider.builder(
                            itemCount: accounts.length,
                            itemBuilder: (ctx, index, i) {
                              final account = accounts[index];
                              return SizedBox(
                                height: 100,
                                width: 300,
                                child: CreditCard(
                                  account: account,
                                  onDelete: () {
                                    _currentAccIndex = 0;
                                  },
                                ),
                              );
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
      },
    );
  }
}
