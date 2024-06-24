import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/components/saving_tab/saving_card.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/shared_widgets/transaction_list/transaction_list.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SavingTab extends StatefulWidget {
  const SavingTab({super.key});

  @override
  State<SavingTab> createState() => _SavingTabState();
}

enum SavingContentTab {
  graph,
  transacts,
  goal,
}

const labelStyle = TextStyle(
  fontSize: 12,
);

final getSavingAccountsDetail = FutureProvider((ref) async {
  final debits = (await ref.watch(accountsProvider).getAccountByType(AccountType.saving)).cast<Saving>();
  return debits;
});

class _SavingTabState extends State<SavingTab> {
  final menuItems = [
    const DropdownMenuEntry(value: SavingContentTab.graph, label: "Biến động số dư"),
    const DropdownMenuEntry(value: SavingContentTab.transacts, label: "Giao dịch liên quan"),
    // const DropdownMenuEntry(value: SavingContentTab.stats, label: "Số liệu"),
    const DropdownMenuEntry(value: SavingContentTab.goal, label: "Mục tiêu"),
  ];

  SavingContentTab _currentContent = SavingContentTab.graph;
  int _currentAccIndex = 0;

  _contentRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: labelStyle)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(value, style: labelStyle),
          ),
        ),
      ],
    );
  }

  _buildContent(Saving account) {
    return switch (_currentContent) {
      SavingContentTab.graph => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Hiển thị biến động trong 30 ngày vừa qua"),
              ),
              const SizedBox(height: 10),
              BalanceChart<Saving>(
                chartHeight: 240,
                account: account,
                timeRange: TimeRange.lastNDays(30),
              ),
            ],
          ),
        ),
      SavingContentTab.transacts => TransactionList(
          account: account,
        ),
      SavingContentTab.goal => account.goal == null
          ? const SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chưa có mục tiêu đề ra"),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${account.goal?.title}"),
                    const SizedBox(height: 15),
                    LinearProgressGauge(
                      value: account.amount,
                      max: account.goal!.targetAmount!,
                      leadingLabel: "Đã tiết kiệm",
                      trailingLabel: "Mục tiêu",
                      mode: GaugeMode.goodOverflow,
                    ),
                    const SizedBox(height: 6),
                    _contentRow("Tiến độ", "${100 * account.amount ~/ account.goal!.targetAmount!} %"),
                    const SizedBox(height: 6),
                    _contentRow("Đến hạn", "${account.goal?.deadline}"),
                    const SizedBox(height: 6),
                    _contentRow("Dự kiến hoàn thành", "${account.goal?.deadline}"),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return ref.watch(getSavingAccountsDetail).when(
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
                                child: SavingCard(
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
