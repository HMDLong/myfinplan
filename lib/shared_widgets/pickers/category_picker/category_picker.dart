import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category/category.dart';
import 'package:myfinplan/screens/category/category_screen.dart';
import 'package:myfinplan/services/categories/category_notifier.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CategoryPicker extends ConsumerStatefulWidget {
  final void Function(Category category) onCategoryChanged;
  final String? Function(String? value)? validator;
  final String? label;
  final bool allowGroup;
  final bool isFormField;
  final Icon? icon;
  final String? initialCategory;

  const CategoryPicker({
    super.key,
    required this.onCategoryChanged,
    this.validator,
    this.label,
    this.allowGroup = false,
    this.isFormField = true,
    this.icon,
    this.initialCategory,
  });

  @override
  ConsumerState<CategoryPicker> createState() => _CategoryPickerState();
}

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

class _CategoryPickerState extends ConsumerState<CategoryPicker> {
  final _categoryController = TextEditingController();

  @override
  void initState() {
    if (widget.initialCategory != null) {
      ref.read(categoryNotifierProvider).getCategoryById(widget.initialCategory!).then((category) {
        _categoryController.text = category?.name ?? (widget.isFormField ? "" : "Tất cả");
      });
    }
    // _categoryController.text = widget.initialCategoryName ?? (widget.isFormField ? "" : "Tất cả");
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _categoryController,
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: StyleRes.formFieldDecor(
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
    );
  }
}
