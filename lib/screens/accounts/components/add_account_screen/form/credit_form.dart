// import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/data/models/transaction/recurrence.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/times.dart';
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
      await ref.read(transactionNotifierProvider.notifier).scheduleTransaction(newCredit.planTransactInfo, TimeType.month);
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
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Hãy nhập tiêu đề";
                }
                _formData["title"] = value;
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            AmountFormField(
              label: "Số tiền đã chi hiện tại",
              onChanged: (value) {
                if (value != null) {
                  _formData["amount"] = value;
                }
              },
            ),
            const SizedBox(height: 10.0),
            AmountFormField(
              label: "Mức hạn định",
              onChanged: (value) {
                if (value != null) {
                  _formData["limit"] = value;
                }
              },
            ),
            const SizedBox(height: 10.0),
            InfullForm(
              onDataChanged: (duedate, interest) {
                if (duedate != null) _formData["duedate"] = duedate;
                if (interest != null) _formData["interest"] = interest;
              },
            ),
            const SizedBox(height: 15.0),
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
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.success("Thêm thành công"));
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
