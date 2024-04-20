import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/domain/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';

class NewDebitForm extends ConsumerStatefulWidget {
  final Debit? prefill;
  const NewDebitForm({super.key, this.prefill});

  @override
  ConsumerState<NewDebitForm> createState() => _NewDebitFormState();
}

class _NewDebitFormState extends ConsumerState<NewDebitForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final newDebit = Debit(
        id: widget.prefill == null ? getRandomKey() : widget.prefill!.id,
        amount: _formData["amount"] as int,
        title: _formData["title"] as String,
      );
      if (widget.prefill == null) {
        await ref.read(accountsProvider).addAccount(newDebit);
      } else {
        await ref.read(accountsProvider).updateAccount(newDebit);
      }
    }
  }

  @override
  void initState() {
    _formData["amount"] = widget.prefill?.amount;
    _formData["title"] = widget.prefill?.title;
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
              initialValue: widget.prefill != null ? widget.prefill!.title : null,
              decoration: formFieldDecor(icon: const Icon(Icons.title), label: const Text("Tiêu đề")),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Hãy nhập tiêu đề";
                }
                _formData["title"] = value;
                return null;
              },
              onSaved: (newValue) {
                _formData["title"] = newValue;
              },
            ),
            TextFormField(
              initialValue: widget.prefill != null ? amountToDecimal(widget.prefill!.amount!) : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: formFieldDecor(
                icon: const Icon(CupertinoIcons.money_dollar),
                suffix: const Text('VND'),
                label: const Text("Số tiền"),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Hãy nhập số tiền";
                }
                var parsedAmount = int.tryParse(value);
                if (parsedAmount == null) {
                  parsedAmount = int.tryParse(value.replaceAll(',', ''));
                  if (parsedAmount == null) {
                    return "Hãy nhập số hợp lệ";
                  }
                }
                if (parsedAmount <= 0) {
                  return "Số tiền cần lớn hơn 0";
                }
                _formData["amount"] = parsedAmount;
                return null;
              },
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
                  // .onError((error, stackTrace) {
                  //   print(StackTrace.current);
                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error")));
                  //   Navigator.of(context).pop();
                  // });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
