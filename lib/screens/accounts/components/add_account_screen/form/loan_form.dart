import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/installment_form.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';
import 'infull_form.dart';

class NewLoanForm extends ConsumerStatefulWidget {
  final Loan? prefill;
  const NewLoanForm({super.key, this.prefill});

  @override
  ConsumerState<NewLoanForm> createState() => _NewLoanFormState();
}

class _NewLoanFormState extends ConsumerState<NewLoanForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  var _paymentType = PaymentType.infull;
  String? title;
  int? amount;
  DateTime? duedate;
  double? interest;
  bool? notified;

  String? numericValidator(String? value, String formKey) {
    if (value == null || value.isEmpty) {
      return "Hãy nhập số tiền";
    }
    final parsedAmount = int.tryParse(value);
    if (parsedAmount == null) {
      return "Cần là số";
    }
    if (parsedAmount < 0) {
      return "Cần lớn hơn 0";
    }
    _formData[formKey] = parsedAmount;
    return null;
  }

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final newDebt = Loan(
        id: widget.prefill?.id ?? getRandomKey(),
        title: title!,
        amount: (amount ?? 0) * -1,
        payment: switch (_paymentType) {
          PaymentType.infull => Infull(
              duedate: duedate,
              lateInterest: interest,
              minPayment: (_formData["amount"] ?? 0) * -1,
            ),
          PaymentType.installment => AmortizingFixedTermPayment(
              term: _formData["term"],
              interestRate: interest! / 100,
              monthlyPayDate: duedate,
            ),
        },
      );
      if (widget.prefill != null) {
        ref.read(accountsProvider.notifier).updateAccount(newDebt);
      } else {
        ref.read(accountsProvider.notifier).addAccount(newDebt);
      }
    }
  }

  @override
  void initState() {
    notified = true;
    final prefill = widget.prefill;
    if (prefill != null) {
      title = prefill.title;
      amount = prefill.amount.abs();
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
            TextFormField(
              decoration: formFieldDecor(
                icon: const Icon(Icons.title),
                label: const Text("Tiêu đề"),
              ),
              initialValue: title,
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
              label: "Số tiền",
              initValue: amount,
              onChanged: (value) {
                if (value == null) return;
                amount = value;
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const SizedBox(width: 10, height: 20),
                const Text("Loại hình chi trả", style: TextStyle(fontSize: 14.0)),
                const SizedBox(width: 10.0),
                Radio<PaymentType>(
                  value: PaymentType.installment,
                  groupValue: _paymentType,
                  onChanged: (paymentType) {
                    if (paymentType != null) {
                      setState(() {
                        _paymentType = paymentType;
                      });
                    }
                  },
                ),
                const Text("Trả góp", style: TextStyle(fontSize: 14.0)),
                const SizedBox(width: 10.0),
                Radio<PaymentType>(
                  value: PaymentType.infull,
                  groupValue: _paymentType,
                  onChanged: (paymentType) {
                    if (paymentType != null) {
                      setState(() {
                        _paymentType = paymentType;
                      });
                    }
                  },
                ),
                const Text("Trả đủ", style: TextStyle(fontSize: 14.0)),
              ],
            ),
            const SizedBox(height: 10.0),
            (switch (_paymentType) {
              PaymentType.infull => InfullForm(onDataChanged: (duedate, interest) {
                  if (duedate != null) this.duedate = duedate;
                  if (interest != null) this.interest = interest;
                }),
              PaymentType.installment => InstallmentForm(
                  formData: _formData,
                  onDataChanged: (term, duedate, interest) {
                    if (duedate != null) this.duedate = duedate;
                    if (interest != null) this.interest = interest;
                    if (term != null) _formData["term"] = term;
                  }),
            }),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(
                  flex: 8,
                  child: Text("Nhắc tôi khi đến ngày thực hiện"),
                ),
                Expanded(
                  flex: 2,
                  child: Switch(
                    value: notified!,
                    onChanged: (value) {
                      notified = value;
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
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
                _onSubmit().then((value) {
                  Navigator.of(context).pop();
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackbar.failure(error.toString()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
