import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/category_group.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/styles.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  ParentCategory? parent;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final newCategory = Category(
        id: parent!.getNewChildId(),
        name: name!,
        icon: parent!.icon,
      );
      await ref.read(categoryNotifierProvider.notifier).addCategory(newCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thêm danh mục",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
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
                      decoration: formFieldDecor(
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
                      decoration: formFieldDecor(
                        label: const Text("data"),
                        icon: const Icon(Icons.category_rounded),
                      ),
                      items: categoryGroups.values.map((group) {
                        return DropdownMenuItem(value: group, child: Text(group.name));
                      }).toList(),
                      onChanged: (value) {
                        parent = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox.expand(
              child: ElevatedButton(
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
        ],
      ),
    );
  }
}
