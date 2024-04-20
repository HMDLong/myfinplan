import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/domain/categories/get_categories_with_budget.dart';
import 'package:myfinplan/presentation/home/home_screen.dart';
import 'package:myfinplan/presentation/plan/budgets/budget_screen.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BudgetSection extends StatefulWidget {
  const BudgetSection({super.key});

  @override
  State<BudgetSection> createState() => _BudgetSectionState();
}

class _BudgetSectionState extends State<BudgetSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Budget",
          onLinkTap: () {
            pushNewScreen(context, screen: const BudgetScreen());
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final totalBudgetSpent = ref.watch(getTotalBudgetSpent).when(
                  data: (data) => data,
                  error: (error, _) => -1,
                  loading: () => 0,
                );
            final totalBudgetAmount = ref.watch(getTotalBudgetAmount).when(
                  data: (data) => data,
                  error: (error, _) => -1,
                  loading: () => 0,
                );

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
              clipBehavior: Clip.antiAlias,
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Bạn đã tiêu ${amountToDecimal(totalBudgetSpent)} trong tổng quỹ ${amountToDecimal(totalBudgetAmount)}.",
                      softWrap: true,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    LinearProgressGauge(
                      value: totalBudgetSpent,
                      max: totalBudgetAmount,
                      mode: GaugeMode.limit,
                      leadingLabel: "Đã chi",
                      trailingLabel: "Còn lại",
                      trailingValue: totalBudgetAmount - totalBudgetSpent,
                      showOverflow: true,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
