// import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';
import 'infull_form.dart';

class NewCreditForm extends ConsumerStatefulWidget {
  final Credit? prefill;
  const NewCreditForm({super.key, this.prefill});

  @override
  ConsumerState<NewCreditForm> createState() => _NewCreditFormState();
}

class _NewCreditFormState extends ConsumerState<NewCreditForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  String? numericValidator(String? value, String formKey) {
    if (value == null || value.isEmpty) {
      return "Hãy nhập số tiền";
    }
    final parsedAmount = int.tryParse(value);
    if (parsedAmount == null) {
      return "Cần là số";
    }
    if (parsedAmount < 0) {
      return "Số tiền cần lớn hơn 0";
    }
    _formData[formKey] = parsedAmount;
    return null;
  }

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final newCredit = Credit(
        id: getRandomKey(),
        title: _formData["title"],
        amount: (_formData["limit"]) * -1 + (_formData["amount"] ?? 0),
        limit: (_formData["limit"]) * -1,
        payment: Infull(
          duedate: _formData["duedate"],
          lateInterest: _formData["interest"],
        ),
      );
      await ref.read(accountsProvider).addAccount(newCredit);
    }
  }

  @override
  void initState() {
    _formData["isNotified"] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            TextFormField(
              decoration: formFieldDecor(
                icon: const Icon(Icons.title),
                label: const Text("Tiêu đề"),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Hãy nhập tiêu đề";
                }
                _formData["title"] = value;
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              initialValue: "0",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: formFieldDecor(
                icon: const Icon(CupertinoIcons.money_dollar),
                label: const Text("Số tiền đã chi hiện tại"),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => numericValidator(value, "amount"),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              initialValue: "0",
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: formFieldDecor(
                icon: const Icon(CupertinoIcons.money_dollar),
                label: const Text("Mức hạn định"),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => numericValidator(value, "limit"),
            ),
            const SizedBox(height: 20.0),
            InfullForm(
              onDataChanged: (duedate, interest) {
                if (duedate != null) _formData["duedate"] = duedate;
                if (interest != null) _formData["interest"] = interest;
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Expanded(
                  flex: 8,
                  child: Text("Nhắc tôi khi đến ngày thực hiện"),
                ),
                Expanded(
                  flex: 2,
                  child: Switch(
                    value: _formData["isNotified"],
                    onChanged: (value) {
                      _formData["isNotified"] = value;
                    },
                  ),
                )
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                child: const Text("Xác nhận"),
                onPressed: () {
                  _onSubmit().then((_) {
                    // ScaffoldMessenger.of(context).showSnackBar(customSnackBar("Thêm thành công"));
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
