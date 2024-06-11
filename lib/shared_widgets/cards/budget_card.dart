import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/providers/categories/get_categories_with_budget.dart';
import 'package:myfinplan/screens/plan/budgets/budget_detail/budget_detail_screen.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BudgetCard extends StatefulWidget {
  final Category category;
  final bool isCompact;
  final bool showTimeRange;

  const BudgetCard({
    super.key,
    this.isCompact = true,
    this.showTimeRange = true,
    required this.category,
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

final class _BudgetCardState extends State<BudgetCard> {
  @override
  Widget build(BuildContext context) {
    final currentMonth = TimeRange.rangeByType(TimeType.month);
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: BudgetDetailScreen(category: widget.category),
        );
      },
      child: SizedBox(
        width: 200,
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.blue.shade300, width: 0.5),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.showTimeRange
                    ? Text(
                        "${widget.category.budget?.period}",
                        style: const TextStyle(fontSize: 10),
                      )
                    : const SizedBox(height: 0.1),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return ref.watch(getTotalSpentByCategory(CategoryQueryDetail(widget.category.id, range: currentMonth))).when(
                          data: (data) {
                            return LinearProgressGauge(
                              value: data.abs(),
                              max: widget.category.budget!.amount,
                              trailingValue: widget.category.budget!.amount,
                              labelFontSize: 10,
                              valueFontSize: 10,
                              showOverflow: true,
                              mode: GaugeMode.limit,
                            );
                          },
                          error: (error, _) => const SizedBox(
                            child: Text(widgetErrorMessage),
                          ),
                          loading: () => const CircularProgressIndicator(),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
