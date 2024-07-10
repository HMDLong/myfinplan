import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/data/models/category/category_group/category_group.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/constants/predefined_categories.dart';
import 'package:myfinplan/utils/styles.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  final Category? prefill;
  const AddCategoryScreen({super.key, this.prefill});

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  ParentCategory? parent;
  late Level level;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final newCategory = Category(
        id: parent!.getNewChildId(),
        name: name!,
        icon: parent!.icon,
        level: level,
      );
      if (widget.prefill == null) {
        await ref.read(categoryNotifierProvider.notifier).addCategory(newCategory);
      } else {
        await ref.read(categoryNotifierProvider.notifier).updateCategory(newCategory);
      }
    }
  }

  @override
  void initState() {
    final prefill = widget.prefill;
    if (prefill != null) {
      name = prefill.name;
      parent = categoryGroups[prefill.parentId];
      level = prefill.level;
    } else {
      level = Level.may;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StyleRes.defaultStyledAppBar(
        title: "Thêm danh mục",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: name,
                        decoration: StyleRes.formFieldDecor(
                          label: const Text("Tiêu đề"),
                          icon: const Icon(Icons.title_rounded),
                        ),
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Hãy điền";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ParentCategory>(
                        value: parent,
                        decoration: StyleRes.formFieldDecor(
                          label: const Text("Nhóm danh mục"),
                          icon: const Icon(Icons.account_tree),
                        ),
                        items: categoryGroups.values.map((group) {
                          return DropdownMenuItem(value: group, child: Text(group.name));
                        }).toList(),
                        onChanged: (value) {
                          parent = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Level>(
                        value: level,
                        decoration: StyleRes.formFieldDecor(
                          label: const Text("Mức độ quan trọng"),
                          icon: const Icon(Icons.align_vertical_bottom_sharp),
                        ),
                        items: Level.values.map((group) {
                          return DropdownMenuItem(value: group, child: Text(group.name));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            level = value;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: SizedBox.expand(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: CupertinoColors.activeBlue,
                    ),
                    child: const Text("Xác nhận"),
                    onPressed: () {
                      _submit().then((value) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(CustomSnackbar.success(""));
                        Navigator.of(context).pop();
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(CustomSnackbar.failure(""));
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
