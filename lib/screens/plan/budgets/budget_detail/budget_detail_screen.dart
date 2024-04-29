import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/screens/plan/budgets/budget_tab.dart';
import 'package:myfinplan/utils/styles.dart';

class BudgetDetail {}

class BudgetDetailScreen extends StatefulWidget {
  final Category category;
  const BudgetDetailScreen({super.key, required this.category});

  @override
  State<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "",
        onBackPressed: () => Navigator.pop(context),
        trailings: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [],
      ),
    );
  }
}
