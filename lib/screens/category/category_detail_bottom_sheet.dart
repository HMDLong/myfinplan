import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/screens/category/add_category_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CategoryDetailBottomSheet extends ConsumerWidget {
  final Category category;
  const CategoryDetailBottomSheet({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.blue.shade50,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: CupertinoColors.activeBlue,
            child: Row(
              children: [
                const Text(
                  "Chi tiết danh mục",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        pushNewScreen(context, screen: AddCategoryScreen(prefill: category));
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(category.icon.toMaterialIconData(), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.account_tree_rounded, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title("Nhóm"),
                        const SizedBox(height: 4),
                        _value("abc"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.align_vertical_bottom_rounded, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title("Mức độ quan trọng"),
                        const SizedBox(height: 4),
                        Text(
                          switch (category.level) {
                            Level.may => "Tùy ý",
                            Level.must => "Bắt buộc",
                            Level.income => "Thu nhập",
                            Level.saving => "Tiết kiệm",
                          },
                          style: const TextStyle(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // DropdownButtonFormField(
                        //   value: category.level,
                        //   items: const [
                        //     DropdownMenuItem(value: Level.may, child: Text("Tùy ý")),
                        //     DropdownMenuItem(value: Level.must, child: Text("Bắt buộc")),
                        //   ],
                        //   onChanged: (value) {},
                        // ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _value(String value) {
    return Text(value);
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w600),
    );
  }
}
