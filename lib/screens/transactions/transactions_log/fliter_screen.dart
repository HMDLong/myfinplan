import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/timerange_picker/timerange_picker.dart';
import 'package:myfinplan/screens/transactions/transactions_log/transact_log_screen.dart';
import 'package:myfinplan/utils/styles.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final FilterDetail _formData;

  @override
  void initState() {
    _formData = ref.read(filterDetailProvider);
    super.initState();
  }

  void _onSubmit() {
    ref.read(filterDetailProvider.notifier).state = _formData.copyWith();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Bộ lọc",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _FilterDataRow(
                  const Text("Thời gian"),
                  TimerangePicker(
                    onTimeChanged: (value) {
                      _formData.timeRange = value;
                    },
                  ),
                ),
                CategoryPicker(
                  icon: const Icon(Icons.category_rounded),
                  allowGroup: true,
                  onCategoryChanged: (category) {
                    _formData.categoryId = category.id;
                  },
                  isFormField: false,
                ),
                AccountPicker(
                  onAccountChanged: (account) {
                    _formData.fromAcc = account;
                  },
                  label: "Tài khoản nguồn",
                ),
                AccountPicker(
                  onAccountChanged: (account) {
                    _formData.toAcc = account;
                  },
                  label: "Tài khoản đích",
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: _onSubmit,
          child: const Text("Xác nhận"),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Đặt lại"),
        )
      ],
    );
  }
}

class _FilterDataRow extends StatelessWidget {
  final Widget label;
  final Widget field;

  const _FilterDataRow(this.label, this.field);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(child: label),
        ),
        Expanded(
          flex: 4,
          child: Center(child: field),
        ),
      ],
    );
  }
}
