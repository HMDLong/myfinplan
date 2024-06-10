import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/date_picker.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/times.dart';

class NewPlanTransactScreen extends ConsumerStatefulWidget {
  const NewPlanTransactScreen({super.key});

  @override
  ConsumerState<NewPlanTransactScreen> createState() => _NewPlanTransactScreenState();
}

class _NewPlanTransactScreenState extends ConsumerState<NewPlanTransactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  // TransactionType transactionType = TransactionType.expense;
  int period = 0;

  @override
  void initState() {
    _formData["isNotified"] = true;
    _formData["period"] = TimeType.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thông tin bản ghi",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      AmountFormField(
                        label: "Số tiền",
                        onChanged: (value) {
                          _formData["amount"] = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      CategoryPicker(
                        icon: const Icon(Icons.category_rounded),
                        onCategoryChanged: (value) {
                          _formData["category"] = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          inputLabelWithPadding("Kì hạn"),
                          Radio(
                            value: 0,
                            groupValue: period,
                            onChanged: (value) => setState(() {
                              period = value ?? period;
                            }),
                          ),
                          inputLabelWithPadding("Định kỳ"),
                          const SizedBox(width: 15),
                          Radio(
                            value: 1,
                            groupValue: period,
                            onChanged: (value) => setState(() {
                              period = value ?? period;
                            }),
                          ),
                          inputLabelWithPadding("Một lần"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomDatePicker(
                        onDatePicked: (pickedDate) => _formData["date"] = pickedDate,
                      ),
                      const SizedBox(height: 10),
                      if (period == 0)
                        DropdownButtonFormField<TimeType>(
                          decoration: formFieldDecor(
                            icon: const Icon(Icons.timelapse_rounded),
                            label: const Text("Chu kỳ"),
                          ),
                          value: _formData["period"],
                          items: const [
                            DropdownMenuItem(value: TimeType.month, child: Text("Hàng tháng")),
                            DropdownMenuItem(value: TimeType.week, child: Text("Hàng tuần")),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _formData["period"] = value;
                            });
                          },
                        ),
                      const SizedBox(height: 10),
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
                                setState(() {
                                  _formData["isNotified"] = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _onSubmit().then((value) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(CustomSnackbar.success(addSuccessMessage));
                                Navigator.of(context).pop();
                              }).onError((error, stackTrace) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(CustomSnackbar.failure("$error"));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: CupertinoColors.activeBlue,
                            ),
                            child: const SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Center(child: Text("Xác nhận")),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final newPlanTransact = Transaction.planTransact(
        planId: getRandomKey(),
        planTimestamp: _formData["date"],
        categoryId: _formData["category"].id,
        categoryName: _formData["category"].name,
        planAmount: _formData["amount"],
      );
      await ref.read(transactionNotifierProvider.notifier).scheduleTransaction(newPlanTransact, _formData["period"]);
    }
  }
}
