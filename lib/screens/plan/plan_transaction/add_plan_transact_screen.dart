import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/shared_widgets/pickers/recurrence_picker/recurrent_picker.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/recurrence.dart';

class NewPlanTransactScreen extends ConsumerStatefulWidget {
  final Transaction? prefill;
  const NewPlanTransactScreen({super.key, this.prefill});

  @override
  ConsumerState<NewPlanTransactScreen> createState() => _NewPlanTransactScreenState();
}

enum PeriodicType { repeat, onetime }

class _NewPlanTransactScreenState extends ConsumerState<NewPlanTransactScreen> {
  final _formKey = GlobalKey<FormState>();

  Recurrence? recur;
  late bool notified;
  int? amount;
  String? categoryId;
  String? categoryName;

  @override
  void initState() {
    notified = true;
    final prefill = widget.prefill;
    if (prefill != null) {
      amount = prefill.amount.abs();
      categoryId = prefill.categoryId;
      categoryName = prefill.categoryName;
    }
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
                  initValue: amount,
                  label: "Số tiền",
                  onChanged: (value) {
                    amount = value;
                  },
                ),
                const SizedBox(height: 14),
                CategoryPicker(
                  initialCategoryName: categoryName,
                  icon: const Icon(Icons.category_rounded),
                  onCategoryChanged: (value) {
                    categoryId = value.id;
                    categoryName = value.name;
                  },
                ),
                const SizedBox(height: 14),
                RecurPicker(
                  onChanged: (recur) {
                    this.recur = recur;
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
                        value: notified,
                        onChanged: (value) {
                          setState(() {
                            notified = value;
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
        planId: recur!.toInfoString,
        planTimestamp: DateTime.now(),
        categoryId: categoryId!,
        categoryName: categoryName!,
        planAmount: amount!,
      );
      if (widget.prefill == null) {
        await ref.read(transactionNotifierProvider.notifier).schedule(newPlanTransact, recur!);
      } else {
        await ref.read(transactionNotifierProvider.notifier).updateSchedule();
      }
    }
  }
}
