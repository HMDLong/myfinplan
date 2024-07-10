import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/services/categories/get_categories_with_budget.dart';
import 'package:myfinplan/shared_widgets/cards/budget_card.dart';

class BudgetsCarousel extends ConsumerStatefulWidget {
  const BudgetsCarousel({super.key});

  @override
  ConsumerState<BudgetsCarousel> createState() => _BudgetsCarouselState();
}

class _BudgetsCarouselState extends ConsumerState<BudgetsCarousel> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(getCategoriesWithBudget).when<List<Category>>(
          data: (data) => data.toList(),
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
                return BudgetCard(category: items[index]);
              },
              itemCount: items.length,
            ),
    );
  }
}
