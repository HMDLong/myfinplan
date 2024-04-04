import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/presentation/accounts/components/cash_tab/cash_tab.dart';
import 'package:myfinplan/presentation/accounts/components/credit_tab/credit_tab.dart';
import 'package:myfinplan/presentation/accounts/components/debit_tab/debit_tab.dart';
import 'package:myfinplan/presentation/accounts/components/saving_tab/saving_tab.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

final totalBalanceProvider = FutureProvider((ref) {
  return 100000000;
});

class _AccountsScreenState extends ConsumerState<AccountsScreen> with SingleTickerProviderStateMixin {
  final tabs = [
    const Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tiền mặt"),
          Text("10000000"),
        ],
      ),
    ),
    const Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ghi nợ/ Ví"),
          Text("10000000"),
        ],
      ),
    ),
    const Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tín dụng"),
          Text("10000000"),
        ],
      ),
    ),
    const Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tiết kiệm"),
          Text("10000000"),
        ],
      ),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = ref.watch(totalBalanceProvider).when(
          data: (data) => data,
          error: (error, _) => -2,
          loading: () => -1,
        );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 6,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "Tổng số dư khả dụng",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Text(
              "$totalBalance",
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontSize: 12),
          labelColor: CupertinoColors.activeBlue,
          unselectedLabelColor: CupertinoColors.inactiveGray,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CashTab(),
          DebitTab(),
          CreditTab(),
          SavingTab(),
        ],
      ),
    );
  }
}
