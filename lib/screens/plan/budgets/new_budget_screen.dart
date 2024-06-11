import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/data/models/plan/plan_distribution.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
import 'package:myfinplan/providers/plan/distributor.dart';
import 'package:myfinplan/providers/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/pickers/category_picker/category_picker.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';

class NewBudgetScreen extends ConsumerStatefulWidget {
  const NewBudgetScreen({super.key});

  @override
  ConsumerState<NewBudgetScreen> createState() => _NewBudgetScreenState();
}

final currentAvailableBudget = FutureProvider((ref) async {
  final currentDist = ref.watch(planDistProvider);
  final currentMonth = TimeRange.rangeByType(TimeType.month);
  final incomeTransacts = (await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.income)).where((e) => currentMonth.contain(e.timestamp));
  final currentIncome = incomeTransacts.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount);
  final expectedIncome = incomeTransacts.where((e) => e.planDetail != null).fold(0, (prev, e) => prev + e.planDetail!.planAmount);
  final maxBudget = max(currentIncome, expectedIncome) * (currentDist.dist[ExpenseLevel.may] ?? 1);
  final currentTotalBudget = (await ref.watch(categoryNotifierProvider).getCategories()).where((e) => e.budget != null).fold(0, (prev, e) => prev + e.budget!.amount);
  final availableBudget = maxBudget - currentTotalBudget;
  return availableBudget;
});

class _NewBudgetScreenState extends ConsumerState<NewBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  int recommendAmount = 0;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: "",
        onBackPressed: () => Navigator.pop(context),
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blueAccent.shade400,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Icon(
                      Boxicons.bx_bulb,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Consumer(builder: (context, ref, child) {
                      final availableBudget = ref.watch(currentAvailableBudget).when(
                            data: (data) => data,
                            error: (error, _) => -1,
                            loading: () => 0,
                          );
                      return Wrap(
                        children: [
                          availableBudget >= 0
                              ? Text(
                                  "Số quỹ còn lại có thể sử dụng: ${Formatter.amountToDecimal(availableBudget.toInt())}",
                                  style: const TextStyle(color: Colors.white),
                                )
                              : const Text(
                                  "Hãy thêm thông tin về thu nhập để ứng dụng có thể gợi ý ngân quỹ cho bạn",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryPicker(
                    allowGroup: true,
                    icon: const Icon(Icons.category_rounded),
                    onCategoryChanged: (value) {
                      setState(() {
                        _formData["category"] = value;
                        // recommendAmount = _getRecAmount(value.id).toInt();
                        _formData["amount"] = recommendAmount;
                        _controller.text = "$recommendAmount";
                      });
                    },
                  ),
                  TextFormField(
                    controller: _controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: formFieldDecor(
                      icon: const Icon(CupertinoIcons.money_dollar),
                      suffix: const Text("VND"),
                      label: const Text("Số tiền"),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input amount";
                      }
                      try {
                        int parsedAmount = int.parse(value);
                        if (parsedAmount < 0) {
                          return "Amount should be positive";
                        }
                        _formData["amount"] = parsedAmount;
                      } catch (e) {
                        return "Amount should be integer";
                      }
                      return null;
                    },
                  ),
                  // inputLabelWithPadding("Loại kỳ hạn"),
                  // DropdownMenu(
                  //   initialSelection: _formData["period"] as Periodic,
                  //   dropdownMenuEntries: const [
                  //     DropdownMenuEntry(value: Periodic.weekly, label: "Theo tuần"),
                  //     DropdownMenuEntry(value: Periodic.monthly, label: "Theo tháng"),
                  //     DropdownMenuEntry(value: Periodic.yearly, label: "Theo năm"),
                  //   ],
                  //   onSelected: (value) {
                  //     _formData["period"] = value;
                  //   },
                  // ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text("Xác nhận"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    final newBudget = Budget(
      amount: _formData["amount"],
      period: TimeRange.rangeByType(TimeType.month),
    );
    ref.read(categoryNotifierProvider).addBudget(_formData["category"].id, newBudget).then((value) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(CustomSnackbar.success(budgetAddSuccessMessage));
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(CustomSnackbar.failure(error.toString()));
    });
  }
}
