import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_form_model.dart';
import 'package:myfinplan/screens/transactions/add_transaction/add_transaction_form_vm.dart';
import 'package:myfinplan/screens/transactions/add_transaction/selected_transact_provider.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/accounts_picker/account_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/timestamp_picker.dart';
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

  late AddTransactionFormModel prefill;

  @override
  void initState() {
    prefill = ref.read(addTransactFormVMProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(addTransactFormVMProvider, (prevState, newState) {
      if(prevState != null && prevState.submitState == newState.submitState) {
        return;
      }
      switch (newState.submitState) {
        case SubmitState.idle:
          break;
        case SubmitState.working:
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (ctx) {
              return WillPopScope(
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      Text(newState.message),
                    ],
                  ),
                ),
                onWillPop: () async => false,
              );
            },
          ).then((success) {
            if (success) {
              Navigator.of(context).pop();
            }
          });
          break;
        case SubmitState.success:
          log("pop");
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(CustomSnackbar.success(newState.message));
          break;
        case SubmitState.error:
          Navigator.of(context).pop(false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(CustomSnackbar.failure(newState.message));
          break;
      }
    });
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thông tin bản ghi",
        onBackPressed: () {
          ref.read(selectedTransactionProvider.notifier).reset();
          Navigator.of(context).pop(false);
        },
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                    // initValue: widget.prefill?.amount,
                    initValue: prefill.amount,
                    onChanged: (value) {
                      // amount = value;
                      ref.read(addTransactFormVMProvider.notifier).setFormData(amount: value);
                    },
                  ),
                  const SizedBox(height: 15),
                  TimestampPicker(
                    initValue: prefill.timestamp,
                    // initValue: widget.prefill?.timestamp,
                    onTimeChange: (time) {
                      // timestamp = time;
                      ref.read(addTransactFormVMProvider.notifier).setFormData(timestamp: time);
                    },
                  ),
                  const SizedBox(height: 15),
                  CategoryPicker(
                    // initialCategoryName: widget.prefill?.categoryName,
                    initialCategoryName: prefill.categoryName,
                    onCategoryChanged: (value) {
                      // setState(() {
                      //   categoryId = value.id;
                      //   categoryName = value.name;
                      //   transactionType = value.type;
                      // });
                      log("${value.id},${value.name}");
                      ref.read(addTransactFormVMProvider.notifier).setFormData(
                            categoryId: value.id,
                            categoryName: value.name,
                          );
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
                  // ..._accountPicker(),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final model = ref.watch(addTransactFormVMProvider);
                      return switch (model.transactType) {
                        TransactionType.transact => Column(
                            children: [
                              AccountPicker(
                                label: "Tài khoản nguồn",
                                payableOnly: true,
                                // initAccountName: widget.prefill?.srcAccName,
                                initAccountName: prefill.fromAccountName,
                                onAccountChanged: (Account value) {
                                  // fromAccountId = value.id;
                                  // fromAccountName = value.title;
                                  ref.read(addTransactFormVMProvider.notifier).setFormData(
                                        fromAccountId: value.id,
                                        fromAccountName: value.title,
                                      );
                                },
                              ),
                              AccountPicker(
                                label: "Tài khoản đích",
                                initAccountName: prefill.toAccountName,
                                // initAccountName: widget.prefill?.toAccName,
                                onAccountChanged: (Account value) {
                                  // toAccountId = value.id;
                                  // toAccountName = value.title;
                                  ref.read(addTransactFormVMProvider.notifier).setFormData(
                                        toAccountId: value.id,
                                        toAccountName: value.title,
                                      );
                                },
                              ),
                            ],
                          ),
                        TransactionType.income => AccountPicker(
                            payableOnly: true,
                            label: "Tài khoản đích",
                            // initAccountName: widget.prefill?.srcAccName,
                            initAccountName: prefill.toAccountName,
                            onAccountChanged: (Account value) {
                              // toAccountId = value.id;
                              // toAccountName = value.title;
                              ref.read(addTransactFormVMProvider.notifier).setFormData(
                                    toAccountId: value.id,
                                    toAccountName: value.title,
                                  );
                            },
                          ),
                        TransactionType.expense => AccountPicker(
                            payableOnly: true,
                            label: "Tài khoản nguồn",
                            // initAccountName: widget.prefill?.srcAccName,
                            initAccountName: prefill.fromAccountName,
                            onAccountChanged: (Account value) {
                              // fromAccountId = value.id;
                              // fromAccountName = value.title;
                              ref.read(addTransactFormVMProvider.notifier).setFormData(
                                    fromAccountId: value.id,
                                    fromAccountName: value.title,
                                  );
                            },
                          ),
                        null => const SizedBox(height: 1),
                      };
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: prefill.description,
                    keyboardType: TextInputType.text,
                    decoration: formFieldDecor(
                      icon: const Icon(Icons.textsms_outlined),
                      label: const Text("Mô tả"),
                    ),
                    onSaved: (newValue) {
                      // description = newValue;
                      ref.read(addTransactFormVMProvider.notifier).setFormData(description: newValue);
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
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    ref.read(addTransactFormVMProvider.notifier).submit();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
