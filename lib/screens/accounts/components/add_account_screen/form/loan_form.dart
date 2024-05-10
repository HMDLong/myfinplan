import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/debt.dart';
import 'package:myfinplan/data/models/account/payment.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/screens/accounts/components/add_account_screen/form/installment_form.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';
import 'infull_form.dart';

class NewLoanForm extends ConsumerStatefulWidget {
  const NewLoanForm({super.key});

  @override
  ConsumerState<NewLoanForm> createState() => _NewLoanFormState();
}

class _NewLoanFormState extends ConsumerState<NewLoanForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  var _paymentType = PaymentType.infull;

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

  void _onSubmit() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final newDebt = Loan(
        id: getRandomKey(),
        title: _formData["title"],
        amount: (_formData["amount"] ?? 0) * -1,
        payment: switch (_paymentType) {
          PaymentType.infull => Infull(
              duedate: _formData["duedate"],
              lateInterest: _formData["interest"],
              minPayment: (_formData["amount"] ?? 0) * -1,
            ),
          PaymentType.installment => AmortizingFixedTermPayment(
              term: _formData["term"],
              interestRate: _formData["interest"] / 100,
              monthlyPayDate: _formData["duedate"],
            ),
        },
      );
      ref.read(accountsProvider).addAccount(newDebt).then((value) {
        Navigator.of(context).pop();
      });
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
            const SizedBox(height: 15.0),
            AmountFormField(
              label: "Số tiền",
              onChanged: (value) {
                if (value == null) return;
                _formData["amount"] = value;
              },
            ),
            const SizedBox(height: 15.0),
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
            (switch (_paymentType) {
              PaymentType.infull => InfullForm(onDataChanged: (duedate, interest) {
                  if (duedate != null) _formData["duedate"] = duedate;
                  if (interest != null) _formData["interest"] = interest;
                }),
              PaymentType.installment => InstallmentForm(
                  formData: _formData,
                  onDataChanged: (term, duedate, interest) {
                    if (duedate != null) _formData["duedate"] = duedate;
                    if (interest != null) _formData["interest"] = interest;
                    if (term != null) _formData["term"] = term;
                  }),
            }),
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
                  _onSubmit();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
