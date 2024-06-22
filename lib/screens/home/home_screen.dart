import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/providers/accounts/accounts/account_usecases.dart';
import 'package:myfinplan/screens/home/components/account_summary_section.dart';
import 'package:myfinplan/screens/home/components/budget_carousel.dart';
import 'package:myfinplan/screens/home/components/latest_transaction_section.dart';
import 'package:myfinplan/screens/home/components/spending_chart/spending_chart.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_screen.dart';
import 'package:myfinplan/screens/transactions/transact_log_screen.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tổng số dư',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return Text(
                    Formatter.amountToDecimal(
                      ref.watch(totalBalanceProvider).when(
                            data: (data) => data,
                            error: (error, _) => -1,
                            loading: () => 0,
                          ),
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const SectionTitle(title: "Tài khoản của bạn"),
              const AccountSummarySection(),
              const SizedBox(height: 10),
              const SectionTitle(title: "Ngân quỹ tháng này"),
              const BudgetsCarousel(),
              const SizedBox(height: 10),
              const SectionTitle(title: "Báo cáo chi tiêu"),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: SpendingChart(),
                ),
              ),
              const SizedBox(height: 10),
              SectionTitle(
                title: 'Các khoản thu chi',
                onLinkTap: () {
                  pushNewScreen(context, screen: const RecordScreen());
                },
              ),
              const LatestTransactionsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CupertinoColors.activeBlue,
        onPressed: () {
          pushNewScreen(context, screen: const AddOrEditTransactScreen());
        },
        child: const Icon(Icons.post_add_rounded),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final void Function()? onLinkTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (onLinkTap != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onLinkTap,
                  child: const Text(
                    "Chi tiết",
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
