import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/timestamp_picker.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';

class AddOrEditTransactScreen extends ConsumerStatefulWidget {
  final Transaction? prefill;
  const AddOrEditTransactScreen({
    super.key,
    this.prefill,
  });

  @override
  ConsumerState<AddOrEditTransactScreen> createState() => _AddOrEditTransactScreenState();
}

class _AddOrEditTransactScreenState extends ConsumerState<AddOrEditTransactScreen> {
  final _formKey = GlobalKey<FormState>();

  String? recordId;
  int? amount;
  // Category? category;
  String? categoryId;
  String? categoryName;
  String? description;
  DateTime? timestamp;
  TransactionType? transactionType;
  String? fromAccountId;
  String? fromAccountName;
  String? toAccountId;
  String? toAccountName;

  @override
  void initState() {
    final prefill = widget.prefill;
    if (prefill != null) {
      recordId = prefill.id;
      amount = prefill.amount;
      categoryId = prefill.categoryId;
      categoryName = prefill.categoryName;
      timestamp = prefill.timestamp;
      description = prefill.description;
      fromAccountId = prefill.accId;
      fromAccountName = prefill.accName;
      toAccountId = prefill.toAccId;
      toAccountName = prefill.toAccName;
    }
    super.initState();
  }

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final prefill = widget.prefill;
      if (prefill != null) {
        prefill.timestamp = timestamp!;
        prefill.amount = amount!;
        prefill.categoryId = categoryId!;
        prefill.categoryName = categoryName!;
        prefill.accId = fromAccountId;
        prefill.accName = fromAccountName;
        prefill.toAccId = toAccountId;
        prefill.toAccName = toAccountName;
        prefill.description = description;
        await ref.read(transactionNotifierProvider.notifier).updateTransaction(prefill);
      } else {
        Transaction newTransaction = Transaction(
          id: recordId ?? getRandomKey(),
          timestamp: timestamp!,
          amount: amount! *
              switch (transactionType) {
                TransactionType.expense => -1,
                TransactionType.income => 1,
                _ => 1,
              },
          categoryId: categoryId!,
          categoryName: categoryName!,
          accId: fromAccountId,
          accName: fromAccountName,
          toAccId: toAccountId,
          toAccName: toAccountName,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thông tin bản ghi",
        onBackPressed: () => Navigator.of(context).pop(false),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8),
                  AmountFormField(
                    label: "Số tiền",
                    initValue: widget.prefill?.amount,
                    onChanged: (value) {
                      amount = value;
                    },
                  ),
                  const SizedBox(height: 15),
                  TimestampPicker(
                    initValue: widget.prefill?.timestamp,
                    onTimeChange: (time) {
                      timestamp = time;
                    },
                  ),
                  const SizedBox(height: 15),
                  CategoryPicker(
                    initialCategoryName: widget.prefill?.categoryName,
                    onCategoryChanged: (value) {
                      setState(() {
                        categoryId = value.id;
                        categoryName = value.name;
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
                  const SizedBox(height: 15),
                  AccountPicker(
                    initAccountName: widget.prefill?.accName,
                    onAccountChanged: (Account value) {
                      fromAccountId = value.id;
                      fromAccountName = value.title;
                    },
                  ),
                  const SizedBox(height: 15),
                  (switch (transactionType) {
                    TransactionType.transact => AccountPicker(
                        label: "Tài khoản đích",
                        initAccountName: widget.prefill?.toAccName,
                        onAccountChanged: (Account value) {
                          toAccountId = value.id;
                          toAccountName = value.title;
                        },
                      ),
                    _ => const SizedBox(height: 5.0),
                  }),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: formFieldDecor(
                      icon: const Icon(Icons.textsms_outlined),
                      label: const Text("Mô tả"),
                    ),
                    onSaved: (newValue) {
                      description = newValue;
                    },
                  ),
                ],
              ),
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
                    Navigator.of(context).pop(true);
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
