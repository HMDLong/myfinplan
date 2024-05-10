import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/credit_form.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/debit_form.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/loan_form.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/saving_form.dart';
import 'package:myfinplan/shared_widgets/menu/menu.dart';

class AddOrEditAccountScreen extends StatefulWidget {
  final AccountType? initType;
  const AddOrEditAccountScreen({super.key, this.initType});

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
            AccountType.credit => const NewCreditForm(),
            AccountType.debit => const NewDebitForm(),
            AccountType.saving => const NewSavingForm(),
            AccountType.loan => const NewLoanForm(),
            _ => const SizedBox(),
          })
        ],
      ),
    );
  }
}
