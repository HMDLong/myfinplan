import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/timestamp_picker.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';

class AddRecordScreen extends ConsumerStatefulWidget {
  final Transaction? prefill;
  const AddRecordScreen({
    super.key,
    this.prefill,
  });

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  String? recordId;
  int? amount;
  Category? category;
  String? description;
  DateTime? timestamp;
  TransactionType? transactionType;
  Account? fromAccount;
  Account? toAccount;

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Transaction newTransaction = Transaction(
        id: getRandomKey(),
        timestamp: timestamp!,
        amount: amount! *
            switch (transactionType) {
              TransactionType.expense => -1,
              TransactionType.income => 1,
              _ => 1,
            },
        accId: fromAccount?.id,
        toAccId: toAccount?.id,
        categoryId: category!.id,
        categoryName: category!.name,
        description: description,
      );
      await ref.read(transactionNotifierProvider.notifier).addTransaction(newTransaction);
      await ref.read(accountsProvider).transfer(
            newTransaction.accId!,
            newTransaction.toAccId,
            newTransaction.amount,
          );
    }
  }

  @override
  void initState() {
    // final prefill = widget.prefill;
    // if (prefill != null) {
    //   recordId = prefill.id;
    //   amount = prefill.amount;
    //   ref.read(categoryNotifierProvider).getCategoryById(prefill.id).then(
    //         (value) => category = value,
    //       );
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thông tin bản ghi",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AmountFormField(
                  onChanged: (value) {
                    amount = value;
                  },
                ),
                TimestampPicker(
                  onTimeChange: (time) {
                    timestamp = time;
                  },
                ),
                CategoryPicker(
                  onCategoryChanged: (value) {
                    setState(() {
                      category = value;
                      transactionType = value.type;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Hãy chọn";
                    }
                    return null;
                  },
                  icon: const Icon(CupertinoIcons.circle_grid_hex),
                ),
                AccountPicker(
                  onAccountChanged: (Account value) {
                    fromAccount = value;
                  },
                ),
                (switch (transactionType) {
                  TransactionType.transact => AccountPicker(
                      label: "Tài khoản đích",
                      onAccountChanged: (Account value) {
                        toAccount = value;
                      },
                    ),
                  _ => const SizedBox(
                      height: 5.0,
                    ),
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: formFieldDecor(
                      icon: const Icon(Icons.textsms_outlined),
                      label: const Text("Mô tả"),
                    ),
                    onSaved: (newValue) {
                      description = newValue;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text("Xác nhận"),
                onPressed: () {
                  _onSubmit().then((value) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(CustomSnackbar.success("Bản ghi được thêm thành công"));
                    Navigator.of(context).pop();
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(CustomSnackbar.failure("Có lỗi xảy ra: $error"));
                  });
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
