import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/presentation/category/category_screen.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CategoryPicker extends StatefulWidget {
  final void Function(Category category) onCategoryChanged;
  final String? Function(String? value)? validator;
  final String? label;
  final bool allowGroup;
  final bool isFormField;
  final Icon? icon;
  final String? initialCategoryName;

  const CategoryPicker({
    super.key,
    required this.onCategoryChanged,
    this.validator,
    this.label,
    this.allowGroup = false,
    this.isFormField = true,
    this.icon,
    this.initialCategoryName,
  });

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

class _CategoryPickerState extends State<CategoryPicker> {
  final _categoryController = TextEditingController();

  @override
  void initState() {
    _categoryController.text = widget.initialCategoryName ?? (widget.isFormField ? "" : "Tất cả");
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          pushNewScreen(
            context,
            screen: CategoryScreen(
              onPicked: (category) {
                widget.onCategoryChanged(category);
                _categoryController.text = category.name;
              },
            ),
          );
        },
        validator: widget.validator,
      ),
    );
  }
}
