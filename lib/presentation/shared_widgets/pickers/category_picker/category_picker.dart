import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/presentation/category/category_screen.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CategoryPicker extends StatefulWidget {
  final TransactionType transactionType;
  final void Function(Category category) onCategoryChanged;
  final String? Function(String? value)? validator;
  final String? label;
  final bool allowGroup;
  final bool requiredPicked;
  final bool isFormField;
  final Icon? icon;
  final Category? initialCategory;

  const CategoryPicker({
    super.key,
    required this.transactionType,
    required this.onCategoryChanged,
    this.validator,
    this.label,
    this.allowGroup = false,
    this.requiredPicked = true,
    this.isFormField = true,
    this.icon,
    this.initialCategory,
  });

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

class _CategoryPickerState extends State<CategoryPicker> {
  final _categoryController = TextEditingController();

  @override
  void initState() {
    _categoryController.text = widget.isFormField ? "" : (widget.initialCategory?.name ?? "Tất cả");
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _categoryController.text = ref.watch(selectedCategoryProvider)?.name ?? (widget.isFormField ? "" : "Tất cả");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _categoryController,
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: formFieldDecor(
          icon: widget.icon,
          label: Text(widget.label ?? "Loại"),
        ),
        onTap: () {
          pushNewScreen(context, screen: CategoryScreen(
            onPicked: (category) {
              // ref.read(selectedCategoryProvider.notifier).state = category;
              widget.onCategoryChanged(category);
              _categoryController.text = category.name;
            },
          ));
        },
        validator: widget.validator,
      ),
    );
  }
}
