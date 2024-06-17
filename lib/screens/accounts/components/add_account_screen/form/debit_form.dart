import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/debit.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
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

  Future<bool> _onSubmit() async {
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
      return true;
    }
    return false;
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            AmountFormField(
              initValue: widget.prefill?.amount,
              label: "Số tiền",
              onChanged: (value) {
                if (value != null) {
                  _formData["amount"] = value;
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("Xác nhận"),
              onPressed: () {
                _onSubmit().then((value) {
                  if (!value) {
                    return;
                  }
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(CustomSnackbar.success("Thêm thành công"));
                  Navigator.of(context).pop();
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(CustomSnackbar.failure("Đã có lỗi xảy ra"));
                  // Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
