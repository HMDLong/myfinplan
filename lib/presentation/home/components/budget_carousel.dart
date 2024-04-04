import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/domain/categories/get_categories_with_budget.dart';

class BudgetsCarousel extends ConsumerStatefulWidget {
  const BudgetsCarousel({super.key});

  @override
  ConsumerState<BudgetsCarousel> createState() => _BudgetsCarouselState();
}

class _BudgetsCarouselState extends ConsumerState<BudgetsCarousel> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(getCategoriesWithBudget).when<List<Category>>(
          data: (data) => data,
          error: (error, _) => [],
          loading: () => [],
        );
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: items.isEmpty
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_document,
                  color: Colors.grey,
                ),
                Text(
                  "Chưa đặt ngân quỹ",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = items[index];
                return item.budget == null ? null : const SizedBox();

                // BudgetCard(
                //     entry: BudgetEntry(
                //     amount: transactionController.getSumOfCategoryInRange(item.id!, getRangeOfTheMonth()),
                //     budget: item.budget!,
                //     category: item,
                //   ));
              },
              itemCount: items.length,
            ),
    );
  }
}
