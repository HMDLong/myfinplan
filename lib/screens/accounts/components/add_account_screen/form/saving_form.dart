import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/saving.dart';
import 'package:myfinplan/services/accounts/accounts/accounts_notifier.dart';
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
  var _hasGoal = false;
  String? title;
  double? interest = 0.0;
  int? period = 0;
  int? amount;
  String? goalTitle;
  int? targetAmount;
  DateTime? deadline;

  Future<bool> _onSubmit() async {
    final newSaving = Saving(
      id: widget.prefill?.id ?? getRandomKey(),
      interest: interest ?? 0,
      title: title ?? "",
      period: period ?? 0,
      amount: amount ?? 0,
    );
    if (_hasGoal) {
      newSaving.goal = Goal(
        targetAmount: targetAmount,
        title: title,
        deadline: deadline,
      );
    }
    if (_formKey.currentState!.validate()) {
      log(newSaving.toString());
      if (widget.prefill == null) {
        await ref.read(accountsProvider.notifier).addAccount(newSaving);
      } else {
        await ref.read(accountsProvider.notifier).updateAccount(newSaving);
      }
      return true;
    }
    log("Not validated: $newSaving");
    return false;
  }

  @override
  void initState() {
    final prefill = widget.prefill;
    if (prefill != null) {
      title = prefill.title;
      interest = prefill.interest;
      period = prefill.period;
      amount = prefill.amount;
      _hasGoal = prefill.goal != null;
      goalTitle = prefill.goal?.title;
      targetAmount = prefill.goal?.targetAmount;
      deadline = prefill.goal?.deadline;
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
            const SizedBox(height: 14),
            TextFormField(
              initialValue: title,
              decoration: formFieldDecor(
                icon: const Icon(Icons.title),
                label: const Text("Tiêu đề"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Hãy điền";
                }
                title = value;
                return null;
              },
              onChanged: (value) {
                title = value;
              },
            ),
            const SizedBox(height: 10),
            AmountFormField(
              initValue: amount,
              label: "Số tiền đã tiết kiệm",
              onChanged: (value) {
                amount = value;
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
                        initialValue: "${interest ?? 0.0}",
                        decoration: formFieldDecor(
                          icon: const Icon(CupertinoIcons.money_dollar),
                          label: const Text("Lãi suất"),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Hãy điền";
                          }
                          final parsed = double.tryParse(value);
                          if (period == null || period == 0) {
                            if (parsed == null || parsed == 0) {
                              return null;
                            }
                            return "Hãy điền";
                          }
                          if (parsed == null) {
                            return "Cần là 1 số";
                          }
                          if (parsed < 0) {
                            return "Cần là số dương";
                          }
                          interest = parsed;
                          return null;
                        },
                        onChanged: (newValue) {
                          interest = double.parse(newValue);
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
                        initialValue: "${period ?? 0}",
                        decoration: formFieldDecor(
                          icon: const Icon(CupertinoIcons.money_dollar),
                          label: const Text("Kỳ hạn"),
                          suffix: const Text("tháng"),
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
                          if (interest == null || interest == 0.0) {
                            if (parsed == 0) {
                              return null;
                            }
                            return "Hãy nhập 'Lãi suất'";
                          }
                          if (parsed < 0) {
                            return "Cần lớn hơn 0";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          period = int.tryParse(value);
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
                const Text("Thêm mục tiêu", style: TextStyle(fontSize: 14.0)),
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
              initialValue: goalTitle,
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
              onChanged: (newValue) {
                goalTitle = newValue;
              },
            ),
            const SizedBox(height: 10),
            AmountFormField(
              initValue: targetAmount,
              enabled: _hasGoal,
              label: "Số tiền mục tiêu",
              onChanged: (value) {
                targetAmount = value;
              },
              validator: (value) {
                if (!_hasGoal) {
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return "Hãy điền";
                }
                final parsedAmount = int.tryParse(value.split(',').join());
                if (parsedAmount == null) {
                  return "Cần là số dương";
                }
                if (parsedAmount <= (amount ?? 0)) {
                  return "Cần phải lớn hơn số tiền gốc";
                }
                amount = parsedAmount;
                return null;
              },
            ),
            const SizedBox(height: 10),
            TimestampPicker(
              initValue: deadline,
              enabled: _hasGoal,
              label: "Ngày đến hạn",
              onTimeChange: (value) {
                deadline = value;
              },
            ),
            const SizedBox(height: 16),
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
                  _onSubmit().then((done) {
                    if (!done) {
                      return;
                    }
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(CustomSnackbar.success("Thêm tài khoản thành công"));
                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(CustomSnackbar.failure("Lỗi: $error"));
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
