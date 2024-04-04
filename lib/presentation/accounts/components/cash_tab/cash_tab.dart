import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/account/cash.dart';
import 'package:myfinplan/presentation/shared_widgets/graphs/balance_chart/balance_chart.dart';
import 'package:myfinplan/presentation/shared_widgets/transaction_list/transaction_list.dart';
import 'package:myfinplan/utils/times.dart';

class CashTab extends StatefulWidget {
  const CashTab({super.key});

  @override
  State<CashTab> createState() => _CashTabState();
}

enum CashContentTab {
  graph,
  transacts,
  stats,
}

class _CashTabState extends State<CashTab> {
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
    final accounts = <Cash>[
      Cash(id: '0', amount: 10000, title: "Tien mat1"),
      Cash(id: '1', amount: 20000, title: "Tien mat2"),
    ];
    return Column(
      children: [
        const SizedBox(height: 10),
        CarouselSlider.builder(
          itemCount: accounts.length,
          itemBuilder: (ctx, index, i) {
            final account = accounts[index];
            return SizedBox(
              height: 100,
              width: 300,
              child: Card(
                color: Colors.blue,
                child: Column(children: [
                  Text("${account.title}"),
                ]),
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
  }
}
