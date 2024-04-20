import 'package:flutter/material.dart';
import 'package:myfinplan/presentation/category/category_screen.dart';
import 'package:myfinplan/presentation/personalize/components/demo_panel.dart';
import 'package:myfinplan/presentation/personalize/widgets/person_item_card.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PersonalizeScreen extends StatefulWidget {
  const PersonalizeScreen({super.key});

  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(title: "Cá nhân"),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Column(
            children: [
              CircleAvatar(),
              Text("Test 1"),
            ],
          ),
          const SizedBox(height: 14),
          PersonalizeItemCard(
            color: Colors.blue.shade50,
            icon: const Icon(Icons.category_rounded),
            label: "Quản lý danh mục",
            onPressed: () {
              pushNewScreen(context, screen: const CategoryScreen());
            },
          ),
          const SizedBox(height: 14),
          PersonalizeItemCard(
            color: Colors.blue.shade50,
            icon: const Icon(Icons.category_rounded),
            label: "Demo panel",
            onPressed: () {
              pushNewScreen(context, screen: const DemoPanel());
            },
          ),
        ],
      ),
    );
  }
}
