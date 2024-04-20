import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/transaction/recurrence.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/menu/transact_type_menu.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/data_picker.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';

class NewPlanTransactScreen extends ConsumerStatefulWidget {
  const NewPlanTransactScreen({super.key});

  @override
  ConsumerState<NewPlanTransactScreen> createState() => _NewPlanTransactScreenState();
}

class _NewPlanTransactScreenState extends ConsumerState<NewPlanTransactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  TransactionType transactionType = TransactionType.expense;
  int period = 0;

  @override
  void initState() {
    _formData["isNotified"] = true;
    _formData["period"] = Periodic.monthly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Thông tin bản ghi",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            TransactionTypeMenu<TransactionType>(
              items: const [
                {"name": "Chi phí", "value": TransactionType.expense},
                {"name": "Thu nhập", "value": TransactionType.income},
              ],
              onTypeChanged: (value) => setState(() {
                transactionType = value;
              }),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: formFieldDecor(
                      icon: const Icon(Icons.textsms_outlined),
                      label: const Text("Tiêu đề"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập tiêu đề";
                      }
                      _formData["title"] = value;
                      return null;
                    },
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: formFieldDecor(
                      icon: const Icon(CupertinoIcons.money_dollar),
                      label: const Text("Số tiền"),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Hãy nhập số tiền";
                      }
                      int parsedAmount = int.parse(value);
                      if (parsedAmount <= 0) {
                        return "Số tiền cần lớn hơn 0";
                      }
                      _formData["amount"] = parsedAmount;
                      return null;
                    },
                  ),
                  CategoryPicker(
                    icon: const Icon(Icons.category_rounded),
                    onCategoryChanged: (value) {
                      _formData["category"] = value;
                    },
                  ),
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
                  (switch (period) {
                    0 => _periodic(),
                    1 => _oneTime(),
                    _ => throw Exception(),
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
                            setState(() {
                              _formData["isNotified"] = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    child: const Text("Xác nhận"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _periodic() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: CustomDatePicker(
            onDatePicked: (pickedDate) => _formData["date"] = pickedDate,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inputLabelWithPadding("Loại kỳ hạn"),
              DropdownMenu(
                initialSelection: Periodic.monthly,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: Periodic.monthly, label: "Hàng tháng"),
                  DropdownMenuEntry(value: Periodic.weekly, label: "Hàng tuần"),
                ],
                onSelected: (value) {
                  _formData["period"] = value;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _oneTime() {
    return CustomDatePicker(onDatePicked: (pickedDate) {
      _formData["date"] = pickedDate;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // final newPlanTransact = Transaction(
      //   id: getRandomKey(),
      //   timestamp: _formData["date"],
      //   amount: _formData["amount"],
      //   categoryId: _formData["category"].id,
      //   categoryName: _formData["category"].name,
      //   planTransactId: (_formData["period"] as Periodic).toString(),
      // );
      final newPlanTransact = Transaction.planTransact(
        planId: getRandomKey(),
        planTimestamp: _formData["date"],
        categoryId: _formData["category"].id,
        categoryName: _formData["category"].name,
        planAmount: _formData["amount"],
      );
      ref.read(transactionNotifierProvider).addTransaction(newPlanTransact);
      Navigator.of(context).pop();
    }
  }
}
