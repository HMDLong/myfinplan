import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/plan/plan_transact_detail.dart';
import 'package:myfinplan/utils/time/recurrence.dart';
import 'package:myfinplan/data/models/transaction/transaction.dart';
import 'package:myfinplan/providers/categories/category_notifier.dart';
// import 'package:myfinplan/screens/plan/budgets/new_budget_screen.dart';
import 'package:myfinplan/screens/plan/plan_transaction/add_plan_transact_screen.dart';
import 'package:myfinplan/screens/plan/plan_transaction/providers/plan_transact_detail_provider.dart';
import 'package:myfinplan/shared_widgets/form/amount_form_field.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/styles.dart';
import 'package:myfinplan/utils/time/time_type.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PlanTransactDetailScreen extends ConsumerStatefulWidget {
  final PlanTransactDetail detail;
  const PlanTransactDetailScreen({
    super.key,
    required this.detail,
  });

  @override
  ConsumerState<PlanTransactDetailScreen> createState() => _PlanTransactDetailScreenState();
}

const cardTitleStyle = TextStyle(
  fontWeight: FontWeight.w600,
);

const cardSubtitleStyle = TextStyle(
  fontSize: 12,
  color: Colors.grey,
);

final amountProvider = StateProvider<int>((ref) => 0);

class _PlanTransactDetailScreenState extends ConsumerState<PlanTransactDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultStyledAppBar(
        title: widget.detail.category.name,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: ref.watch(planTransactsForDetailProvider).when(
        data: (data) {
          final category = ref.watch(selectedCategoryForDetailProvider);
          final planned = data.fold(<String, Transaction>{}, (prev, e) {
            if (e.planDetail != null && !prev.containsKey(e.planDetail!.planId)) {
              prev[e.planDetail!.planId] = e;
            }
            return prev;
          });
          final planAmount = data.fold(0, (prev, e) => prev + (e.planDetail?.planAmount.abs() ?? 0));
          final realAmount = data.fold(0, (prev, e) => prev + e.amount.abs());
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Icon(Boxicons.bx_coin),
                    ),
                    const Expanded(
                      flex: 6,
                      child: Text("Ngân quỹ của tôi", style: cardTitleStyle),
                    ),
                    Expanded(
                      child: IconButton(icon: const Icon(Icons.add), onPressed: budgetAddOrEdit, color: CupertinoColors.activeBlue),
                    ),
                    Expanded(
                      child: IconButton(icon: const Icon(Icons.delete), onPressed: budgetDelete, color: CupertinoColors.activeBlue),
                    ),
                  ],
                ),
                planAmount <= 0 && category?.budget == null
                    ? const SizedBox(
                        height: 100,
                        child: Center(child: Text("Chưa đặt ngân quỹ")),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: LinearProgressGauge(
                          value: realAmount,
                          max: category?.budget == null ? planAmount : category!.budget!.amount,
                          showOverflow: true,
                          mode: GaugeMode.limit,
                          leadingLabel: "Thực tế",
                          trailingLabel: "Hạn mức",
                          labelFontSize: 12,
                          valueFontSize: 14,
                        ),
                      ),
                Row(
                  children: [
                    const Expanded(
                      child: Icon(Boxicons.bx_calendar_event),
                    ),
                    const Expanded(
                      flex: 7,
                      child: Text("Các khoản đã lên lịch", style: cardTitleStyle),
                    ),
                    Expanded(
                      child: IconButton(icon: const Icon(Boxicons.bx_calendar_plus), onPressed: planTransactAdd, color: CupertinoColors.activeBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                planned.isEmpty
                    ? const SizedBox(
                        height: 300,
                        child: Center(child: Text("Chưa có khoản lên lịch")),
                      )
                    : Column(
                        children: planned.values.map((e) {
                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    pushNewScreen(context, screen: NewPlanTransactScreen(prefill: e));
                                  },
                                  icon: Icons.edit_document,
                                  backgroundColor: CupertinoColors.activeBlue,
                                ),
                                SlidableAction(
                                  onPressed: (context) {},
                                  icon: Icons.delete_rounded,
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(category?.icon.toMaterialIconData()),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.categoryName),
                                          const SizedBox(height: 6),
                                          Text(Recurrence.parse(e.planDetail!.planId).toString()),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(Formatter.amountToDecimal(e.planDetail!.planAmount, currency: null)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
        },
        error: (error, _) {
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$error"),
              ],
            ),
          );
        },
        loading: () {
          return const SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  void budgetAddOrEdit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ngân quỹ"),
          content: SizedBox(
            height: 140,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return ref.watch(currentAvailableBudget).when(
                      data: (availableBudget) {
                        log(availableBudget.toString());
                        return availableBudget >= 0
                            ? Text(
                                "Số quỹ còn lại có thể sử dụng: ${Formatter.amountToDecimal(availableBudget.toInt())}",
                                // style: const TextStyle(color: Colors.white),
                              )
                            : const Text(
                                "Hãy thêm thông tin về thu nhập để ứng dụng có thể gợi ý ngân quỹ cho bạn",
                                // style: TextStyle(color: Colors.white),
                              );
                      },
                      error: (error, _) {
                        return Text("$error");
                      },
                      loading: () {
                        return const Text("Đang tính toán");
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                AmountFormField(
                  label: "Số tiền",
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(amountProvider.notifier).state = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref
                    .read(categoryNotifierProvider.notifier)
                    .addBudget(
                      widget.detail.category.id,
                      Budget(
                        amount: ref.read(amountProvider),
                        period: TimeRange.rangeByType(TimeType.month),
                      ),
                    )
                    .then((value) => Navigator.pop(context));
              },
              child: const Text("Xác nhận"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
          ],
        );
      },
    );
  }

  void budgetDelete() {
    if (widget.detail.category.budget == null) {
      return;
    }
    ref.read(categoryNotifierProvider.notifier).deleteBudget(widget.detail.category.id);
  }

  void planTransactAdd() {
    pushNewScreen(context, screen: const NewPlanTransactScreen());
  }
}
