import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/presentation/home/components/account_summary_section.dart';
import 'package:myfinplan/presentation/home/components/budget_carousel.dart';
import 'package:myfinplan/presentation/home/components/latest_transaction_section.dart';
import 'package:myfinplan/presentation/home/components/spending_chart.dart';
import 'package:myfinplan/presentation/transactions/add_transaction_screen/add_transaction_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
              Text(
                "", // amountToDecimal(100000000),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SectionTitle(title: "Tài khoản của bạn"),
              const AccountSummarySection(),
              const SizedBox(height: 10),
              const SectionTitle(title: "Ngân quỹ tháng này"),
              const BudgetsCarousel(),
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
              const SectionTitle(title: 'Các khoản thu chi'),
              const LatestTransactionsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(context, screen: const AddRecordScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
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
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // pushNewScreen(context, screen: const RecordScreen());
                },
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
