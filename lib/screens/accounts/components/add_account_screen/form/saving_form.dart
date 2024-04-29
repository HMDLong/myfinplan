import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/providers/accounts/accounts/accounts_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/timestamp_picker.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';

class NewSavingForm extends ConsumerStatefulWidget {
  final Saving? prefill;
  const NewSavingForm({super.key, this.prefill});

  @override
  ConsumerState<NewSavingForm> createState() => _NewSavingFormState();
}

class _NewSavingFormState extends ConsumerState<NewSavingForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  final _deadlineController = TextEditingController();
  var _hasGoal = false;

  void _onSubmit() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      final newSaving = Saving(id: getRandomKey());
      newSaving.interest = _formData["interest"] ?? 0.0;
      newSaving.amount = _formData["amount"] ?? 0;
      newSaving.title = _formData["title"];
      newSaving.period = _formData["period"] ?? 0;
      if (_hasGoal) {
        newSaving.goal = Goal(
          targetAmount: _formData["targetAmount"] as int,
          title: _formData["goalTitle"] as String,
          deadline: _formData["deadline"] as DateTime,
        );
      }
      ref.read(accountsProvider).addAccount(newSaving).then((_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(CustomSnackbar.success("Thêm tài khoản thành công"));
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(CustomSnackbar.failure("Đã có lỗi xảy ra"));
      });
    }
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
            const SizedBox(height: 5),
            TextFormField(
              decoration: formFieldDecor(
                icon: const Icon(Icons.title),
                label: const Text("Tiêu đề"),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Hãy điền";
                }
                _formData["title"] = value;
                return null;
              },
            ),
            const SizedBox(height: 10),
            AmountFormField(
              initValue: 0,
              label: "Số tiền đã tiết kiệm",
              onChanged: (value) {
                _formData["amount"] = value;
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: "0.0",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: formFieldDecor(icon: const Icon(CupertinoIcons.money_dollar), label: const Text("Lãi suất")),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Hãy điền";
                          }
                          final parsed = double.tryParse(value);
                          if (_formData["period"] == null || _formData["period"] == 0) {
                            if (parsed == null || parsed == 0) {
                              return null;
                            }
                            return "Hãy điền";
                          }
                          if (parsed == null) {
                            return "Cần là 1 số";
                          }
                          if (parsed <= 0) {
                            return "Cần là số dương";
                          }
                          _formData["interest"] = parsed;
                          return null;
                        },
                        onSaved: (newValue) {
                          _formData["interest"] = double.parse(newValue!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: "0",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: formFieldDecor(
                          icon: const Icon(CupertinoIcons.money_dollar),
                          label: const Text("Kỳ hạn"),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Hãy nhập";
                          }
                          final parsed = int.tryParse(value);
                          if (parsed == null) {
                            return "Cần là số";
                          }
                          if (_formData["interest"] == null || _formData["interest"] == 0.0) {
                            if (parsed == 0) {
                              return null;
                            }
                            return "Hãy nhập 'Lãi suất'";
                          }
                          if (parsed <= 0) {
                            return "Cần lớn hơn 0";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10, height: 20),
                const Text(
                  "Thêm mục tiêu",
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(width: 5.0),
                const Text(
                  "(tùy chọn)",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(width: 10.0),
                Checkbox(
                  value: _hasGoal,
                  onChanged: (newValue) {
                    setState(() {
                      _hasGoal = !_hasGoal;
                    });
                  },
                )
              ],
            ),
            TextFormField(
              enabled: _hasGoal,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: formFieldDecor(
                icon: const Icon(Icons.label_outline),
                label: const Text("Tiêu đề"),
              ),
              validator: (value) {
                if (!_hasGoal) {
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return "Hãy thêm tiêu đề";
                }
                return null;
              },
              onSaved: (newValue) {
                _formData["goalTitle"] = newValue;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              enabled: _hasGoal,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: formFieldDecor(
                icon: const Icon(CupertinoIcons.money_dollar),
                label: const Text("Số tiền mục tiêu"),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!_hasGoal) {
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return "Hãy điền";
                }
                final parsedAmount = int.tryParse(value);
                if (parsedAmount == null) {
                  return "Cần là số dương";
                }
                if (parsedAmount <= (_formData["amount"] ?? 0)) {
                  return "Cần phải lớn hơn số tiền gốc";
                }
                _formData["targetAmount"] = parsedAmount;
                return null;
              },
              onSaved: (newValue) {
                if (_hasGoal) {
                  _formData["targetAmount"] = int.parse(newValue!);
                }
              },
            ),
            const SizedBox(height: 10),
            TimestampPicker(
              enabled: _hasGoal,
              label: "Ngày đến hạn",
              onTimeChange: (value) {},
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                child: const Text("Submit"),
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

  _selectDate() async {
    final now = DateTime.now();
    DateTime? pickedDeadline = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year),
      lastDate: DateTime(now.year + 10),
    );

    if (pickedDeadline != null) {
      setState(() {
        _deadlineController.text = DateFormat.yMd().format(pickedDeadline);
        _formData["deadline"] = pickedDeadline;
      });
    }
  }
}
