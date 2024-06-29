import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/credit_form.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/debit_form.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/loan_form.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/saving_form.dart';
import 'package:myfinplan/shared_widgets/menu/menu.dart';

class AddOrEditAccountScreen extends StatefulWidget {
  final AccountType? initType;
  final Account? prefill;
  const AddOrEditAccountScreen({super.key, this.initType, this.prefill});

  @override
  State<AddOrEditAccountScreen> createState() => _AddOrEditAccountScreenState();
}

class _AddOrEditAccountScreenState extends State<AddOrEditAccountScreen> {
  late AccountType newAccountType;

  @override
  void initState() {
    newAccountType = widget.initType ?? AccountType.debit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("${widget.prefill != null}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            )),
        title: const Text(
          "Thông tin tài khoản",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomMenu<AccountType>(
              initValue: widget.initType,
              locked: widget.prefill != null,
              items: const [
                DropdownMenuEntry(value: AccountType.debit, label: "Ví"),
                DropdownMenuEntry(value: AccountType.credit, label: "Tín dụng"),
                DropdownMenuEntry(value: AccountType.saving, label: "Tiết kiệm"),
                DropdownMenuEntry(value: AccountType.loan, label: "Khoản nợ"),
              ],
              onChanged: (newValue) {
                setState(() {
                  newAccountType = newValue;
                });
              },
            ),
          ),
          (switch (newAccountType) {
            AccountType.credit => NewCreditForm(prefill: widget.prefill as Credit?),
            AccountType.debit => NewDebitForm(prefill: widget.prefill as Debit?),
            AccountType.saving => NewSavingForm(prefill: widget.prefill as Saving?),
            AccountType.loan => NewLoanForm(),
            _ => const SizedBox(),
          })
        ],
      ),
    );
  }
}
