import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/credit.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/date_picker.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';

class NewCreditForm extends ConsumerStatefulWidget {
  final Credit? prefill;
  const NewCreditForm({super.key, this.prefill});

  @override
  ConsumerState<NewCreditForm> createState() => _NewCreditFormState();
}

class _NewCreditFormState extends ConsumerState<NewCreditForm> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  int? amount;
  int? limit;
  DateTime? duedate;
  double? interest;
  late bool notified;

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final newCredit = Credit(
        id: widget.prefill?.id ?? getRandomKey(),
        title: title!,
        amount: (amount ?? 0) * -1,
        limit: limit! * -1,
        payment: Infull(
          duedate: duedate,
          lateInterest: interest,
        ),
      );
      await ref.read(accountsProvider).addAccount(newCredit);
    }
  }

  @override
  void initState() {
    notified = true;
    final prefill = widget.prefill;
    if (prefill != null) {
      title = prefill.title;
      amount = prefill.amount.abs();
      limit = prefill.limit.abs();
      duedate = (prefill.payment as Infull).payDate;
      interest = (prefill.payment as Infull).lateInterest;
    }
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
              initialValue: title,
              decoration: formFieldDecor(
                icon: const Icon(Icons.title),
                label: const Text("Tiêu đề"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Hãy nhập tiêu đề";
                }
                title = value;
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            AmountFormField(
              label: "Số tiền đã chi hiện tại",
              initValue: amount,
              onChanged: (value) {
                if (value != null) {
                  amount = value;
                }
              },
            ),
            const SizedBox(height: 10.0),
            AmountFormField(
              label: "Mức hạn định",
              initValue: limit,
              onChanged: (value) {
                if (value != null) {
                  limit = value;
                }
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: CustomDatePicker(
                    onDatePicked: (value) {
                      duedate = value;
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: interest.toString(),
                        decoration: formFieldDecor(
                          icon: const Icon(CupertinoIcons.percent),
                          label: const Text("Lãi suất"),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Hãy nhập";
                          }
                          final parsed = double.tryParse(value);
                          if (parsed == null) {
                            return "Cần là số";
                          }
                          if (parsed < 0) {
                            return "Cần lớn hơn 0";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          interest = double.tryParse(value);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            // InfullForm(
            //   onDataChanged: (duedate, interest) {
            //     if (duedate != null)  = duedate;
            //     if (interest != null) _formData["interest"] = interest;
            //   },
            // ),
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
                    value: notified,
                    onChanged: (value) {
                      notified = value;
                    },
                  ),
                )
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CupertinoColors.activeBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(child: Text("Xác nhận")),
                ),
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
