import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/category_group.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/domain/categories/category_notifier.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/styles.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final void Function(Category)? onPicked;
  const CategoryScreen({super.key, this.onPicked});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  Widget _buildListOfCategory(List<ParentCategory> parents, List<Category> children) {
    return ListView(
      shrinkWrap: true,
      children: parents.map((parent) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(parent.name),
            Wrap(
              runSpacing: 4.0,
              children: children.where((category) => category.parentId == parent.id).map((category) {
                return InputChip(
                  elevation: 4,
                  label: Text(category.name),
                  onPressed: () {
                    if (widget.onPicked != null) {
                      widget.onPicked!(category);
                    }
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: defaultStyledAppBar(
          title: "",
          onBackPressed: () => Navigator.pop(context),
          bottom: const TabBar.secondary(
            labelPadding: EdgeInsets.zero,
            labelStyle: TextStyle(fontSize: 12),
            labelColor: CupertinoColors.activeBlue,
            unselectedLabelColor: CupertinoColors.inactiveGray,
            tabs: [
              Tab(child: Text("Chi phí")),
              Tab(child: Text("Thu nhập")),
              Tab(child: Text("Chuyển khoản")),
            ],
          ),
        ),
        body: FutureBuilder(
          future: ref.watch(categoryNotifierProvider).getCategories(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.expand(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox.expand(
                child: Text("Đã xảy ra lỗi"),
              );
            }
            final parents = categoryGroups.values;
            return TabBarView(
              children: TransactionType.values
                  .map(
                    (transactType) => _buildListOfCategory(
                      parents.where((group) => group.type == transactType).toList(),
                      snapshot.data!,
                    ),
                  )
                  .toList(),
            );
          }),
        ),
      ),
    );
  }
}
