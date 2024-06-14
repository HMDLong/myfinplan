import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/recurrence_picker/recurrent_picker.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/random.dart';
import 'package:myfinplan/utils/styles.dart';

class NewPlanTransactScreen extends ConsumerStatefulWidget {
  const NewPlanTransactScreen({super.key});

  @override
  ConsumerState<NewPlanTransactScreen> createState() => _NewPlanTransactScreenState();
}

enum PeriodicType {
  repeat,
  onetime,
}

class _NewPlanTransactScreenState extends ConsumerState<NewPlanTransactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  late PeriodicType type;

  @override
  void initState() {
    type = PeriodicType.repeat;
    _formData["isNotified"] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "Thông tin bản ghi",
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AmountFormField(
                  label: "Số tiền",
                  onChanged: (value) {
                    _formData["amount"] = value;
                  },
                ),
                const SizedBox(height: 14),
                CategoryPicker(
                  icon: const Icon(Icons.category_rounded),
                  onCategoryChanged: (value) {
                    _formData["category"] = value;
                  },
                ),
                const SizedBox(height: 14),
                RecurPicker(
                  onChanged: (recur) {
                    _formData["period"] = recur;
                  },
                ),
                const SizedBox(height: 14),
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
                Padding(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final newPlanTransact = Transaction.planTransact(
        planId: getRandomKey(),
        planTimestamp: DateTime.now(),
        categoryId: _formData["category"].id,
        categoryName: _formData["category"].name,
        planAmount: _formData["amount"],
      );
      // await ref.read(transactionNotifierProvider.notifier).scheduleTransaction(newPlanTransact, _formData["period"]);
      await ref.read(transactionNotifierProvider.notifier).schedule(newPlanTransact, _formData["period"]);
    }
  }
}
