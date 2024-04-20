import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/category.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/domain/categories/category_notifier.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/add_plan_transact_screen.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:myfinplan/shared_widgets/menu/menu.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PlanTransactionTab extends ConsumerStatefulWidget {
  const PlanTransactionTab({super.key});

  @override
  ConsumerState<PlanTransactionTab> createState() => _PlanTransactionTabState();
}

enum PlanTransactStatus {
  upcoming,
  late,
  paid,
  latePaid,
}

class PlanTransactDetail {
  Category category;
  int plan;
  int actual;

  PlanTransactDetail({
    required this.plan,
    required this.actual,
    required this.category,
  });
}

final getPlanTransactDetail = FutureProvider.family<List<PlanTransactDetail>, TransactionType>((ref, type) async {
  final categories = (await ref.watch(categoryNotifierProvider).getCategories()).where((e) => e.type == type);
  final transactions = await ref.watch(transactionNotifierProvider).getTransactionByType(type);
  final res = <PlanTransactDetail>[];
  for (var category in categories) {
    final cateTransacts = transactions.where((e) => e.categoryId == category.id).toList();
    final actualAmount = cateTransacts.where((e) => e.paid).fold(0, (prev, e) => prev + e.amount).abs();
    final planAmount = cateTransacts.where((e) => e.planTransactId != null).fold(0, (prev, e) => prev + e.amount).abs();
    final data = PlanTransactDetail(plan: planAmount, actual: actualAmount, category: category);
    // check if there are data of category, if not put it at the end so that
    // category with data will appear at the top of the list
    if (planAmount == 0 && actualAmount == 0) {
      res.add(data);
    } else {
      res.insert(0, data);
    }
  }
  return res;
});

class _PlanTransactionTabState extends ConsumerState<PlanTransactionTab> {
  late TransactionType type;
  PlanTransactStatus? status;

  @override
  void initState() {
    type = TransactionType.expense;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        children: [
          CustomMenu(
            items: const [
              DropdownMenuEntry(value: TransactionType.expense, label: "Chi phí"),
              DropdownMenuEntry(value: TransactionType.income, label: "Thu nhập"),
            ],
            onChanged: (newType) {
              setState(() {
                type = newType;
              });
            },
          ),
          const SizedBox(height: 10),
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(getPlanTransactDetail(type)).when(
                    data: (data) {
                      int planTotal = 0;
                      int actualTotal = 0;
                      for (var detail in data) {
                        planTotal += detail.plan;
                        actualTotal += detail.actual;
                      }
                      return Column(
                        children: [
                          LinearProgressGauge(
                            value: actualTotal,
                            max: planTotal,
                            showOverflow: true,
                            mode: type == TransactionType.expense ? GaugeMode.limit : GaugeMode.goodOverflow,
                            leadingLabel: "Thực tế",
                            trailingLabel: "Dự kiến",
                          ),
                          const SizedBox(height: 10),
                          DataTable(
                            dataTextStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            showCheckboxColumn: false,
                            horizontalMargin: 0,
                            columnSpacing: 28.0,
                            columns: const [
                              DataColumn(label: Text("Nhóm")),
                              DataColumn(label: Text("Dự kiến"), numeric: true),
                              DataColumn(label: Text("Thực tế"), numeric: true),
                              DataColumn(label: Text("Chênh lệch"), numeric: true),
                            ],
                            rows: data.map((e) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(e.category.name)),
                                  DataCell(Text(amountToDecimal(e.plan, currency: null))),
                                  DataCell(Text(amountToDecimal(e.actual, currency: null))),
                                  DataCell(Text(amountToDecimal(e.actual - e.plan, currency: null))),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                    error: (error, _) => const SizedBox(
                      child: Text(widgetErrorMessage),
                    ),
                    loading: () => const SizedBox(
                      height: 300,
                      child: CircularProgressIndicator(),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
