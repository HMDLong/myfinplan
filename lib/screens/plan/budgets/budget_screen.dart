import 'package:flutter/material.dart';
import 'package:myfinplan/screens/plan/budgets/new_budget_screen.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(title: ""),
      body: ListView(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreen(context, screen: const NewBudgetScreen());
        },
        child: Icon(Icons.add_card_rounded),
      ),
    );
  }
}
