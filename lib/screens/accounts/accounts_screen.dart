import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/providers/accounts/accounts/account_usecases.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/add_account_screen.dart';
import 'package:myfinplan/screens/accounts/components/cash_tab/cash_tab.dart';
import 'package:myfinplan/screens/accounts/components/credit_tab/credit_tab.dart';
import 'package:myfinplan/screens/accounts/components/debit_tab/debit_tab.dart';
import 'package:myfinplan/screens/accounts/components/loan_tab/loan_tab.dart';
import 'package:myfinplan/screens/accounts/components/saving_tab/saving_tab.dart';
import 'package:myfinplan/screens/home/components/account_summary_section.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> with SingleTickerProviderStateMixin {
  final blankTabs = [
    const Tab(child: Text("Tiền mặt")),
    const Tab(child: Text("Ghi nợ/ Ví")),
    const Tab(child: Text("Tín dụng")),
    const Tab(child: Text("Tiết kiệm")),
    const Tab(child: Text("Vay nợ")),
  ];

  buildTabs() {
    return ref.watch(balanceSummaryProvider).when(
          data: (data) {
            return [
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Tiền mặt"),
                    Text(Formatter.amountToCompact(data[AccountType.cash] ?? 0)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Ghi nợ/ Ví"),
                    Text(Formatter.amountToCompact(data[AccountType.debit] ?? 0)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Tín dụng"),
                    Text(Formatter.amountToCompact(data[AccountType.credit] ?? 0)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Tiết kiệm"),
                    Text(Formatter.amountToCompact(data[AccountType.saving] ?? 0)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vay nợ"),
                    Text(Formatter.amountToCompact(data[AccountType.loan] ?? 0)),
                  ],
                ),
              ),
            ];
          },
          error: (error, _) {
            return blankTabs;
          },
          loading: () => blankTabs,
        );
  }

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        // centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tổng số dư khả dụng",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Text(
              Formatter.amountToDecimal(totalBalance),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle: const TextStyle(fontSize: 12),
          labelColor: CupertinoColors.activeBlue,
          unselectedLabelColor: CupertinoColors.inactiveGray,
          tabs: buildTabs(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              pushNewScreen(context, screen: const AddOrEditAccountScreen());
            },
            icon: const Icon(
              Icons.add_card,
              color: CupertinoColors.activeBlue,
            ),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CashTab(),
          DebitTab(),
          CreditTab(),
          SavingTab(),
          LoanTab(),
        ],
      ),
    );
  }
}
