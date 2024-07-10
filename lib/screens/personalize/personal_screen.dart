import 'package:flutter/material.dart';
import 'package:myfinplan/screens/category/category_screen.dart';
import 'package:myfinplan/screens/personalize/components/demo_panel.dart';
import 'package:myfinplan/screens/personalize/widgets/person_item_card.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PersonalizeScreen extends StatefulWidget {
  const PersonalizeScreen({super.key});

  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

const titleStyle = TextStyle(
  color: Colors.grey,
);

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleRes.defaultStyledAppBar(title: "Cá nhân"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Column(
            children: [
              CircleAvatar(),
              Text("Test 1"),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Thiết lập chung", style: titleStyle),
          PersonalizeItemCard(
            color: Colors.blue.shade50,
            icon: const Icon(Icons.category_rounded),
            label: "Quản lý danh mục",
            onPressed: () {
              pushNewScreen(context, screen: const CategoryScreen());
            },
          ),
          const Divider(indent: 8, endIndent: 18),
          const SizedBox(height: 8),
          const Text("Demo", style: titleStyle),
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
