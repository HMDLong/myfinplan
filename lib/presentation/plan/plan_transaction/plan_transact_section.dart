import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/presentation/home/home_screen.dart';
import 'package:myfinplan/presentation/plan/plan_transaction/plan_transact_screen.dart';
import 'package:myfinplan/shared_widgets/graphs/progress_gauge.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PlanTransactionSection extends ConsumerStatefulWidget {
  const PlanTransactionSection({super.key});

  @override
  ConsumerState<PlanTransactionSection> createState() => _PlanTransactionSectionState();
}

final totalPlanIncomeProvider = FutureProvider((ref) async {
  final transacts = await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.income);
  final planIncomes = transacts.where((element) => element.planTransactId != null).toList();
  if (planIncomes.isEmpty) return 0;
  final res = planIncomes.fold(0, (previousValue, element) => previousValue + element.amount);
  return res;
});

final totalPlanExpenseProvider = FutureProvider((ref) async {
  final transacts = await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.expense);
  final expenses = transacts.where((element) => element.planTransactId != null).toList();
  if (expenses.isEmpty) return 0;
  final res = expenses.fold(0, (previousValue, element) => previousValue + element.amount);
  return res;
});

final totalActualIncomeProvider = FutureProvider((ref) async {
  final transacts = await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.income);
  final incomes = transacts.where((element) => element.planTransactId != null && element.paid).toList();
  if (incomes.isEmpty) return 0;
  final res = incomes.fold(0, (previousValue, element) => previousValue + element.amount);
  return res;
});

final totalActualExpenseProvider = FutureProvider((ref) async {
  final transacts = await ref.watch(transactionNotifierProvider).getTransactionByType(TransactionType.expense);
  final expenses = transacts.where((element) => element.planTransactId != null && element.paid).toList();
  if (expenses.isEmpty) return 0;
  final res = expenses.fold(0, (previousValue, element) => previousValue + element.amount);
  return res;
});

class _PlanTransactionSectionState extends ConsumerState<PlanTransactionSection> {
  @override
  Widget build(BuildContext context) {
    final totalPlanIncome = ref.watch(totalPlanIncomeProvider).when(
          data: (data) => data,
          error: (error, stackTrace) => -1,
          loading: () => 0,
        );
    final totalActualIncome = ref.watch(totalActualIncomeProvider).when(
          data: (data) => data,
          error: (error, stackTrace) => -1,
          loading: () => 0,
        );
    final totalPlanExpense = ref.watch(totalActualExpenseProvider).when(
          data: (data) => data,
          error: (error, stackTrace) => -1,
          loading: () => 0,
        );
    final totalActualExpense = ref.watch(totalActualExpenseProvider).when(
          data: (data) => data,
          error: (error, stackTrace) => -1,
          loading: () => 0,
        );
    return Column(
      children: [
        SectionTitle(
          title: "Các khoản lên lịch",
          onLinkTap: () {
            pushNewScreen(context, screen: const PlanTransactScreen());
          },
        ),
        Text("Khoản thu"),
        LinearProgressGauge(
          value: totalActualIncome,
          max: totalPlanIncome,
          mode: GaugeMode.goodOverflow,
          leadingLabel: "Thục thu",
          trailingLabel: "Dự kiến",
          showOverflow: true,
        ),
        Text("Khoản chi"),
        LinearProgressGauge(
          showOverflow: true,
          value: totalActualExpense,
          max: totalPlanExpense,
          mode: GaugeMode.limit,
          leadingLabel: "Thục chi",
          trailingLabel: "Dự kiến",
        ),
      ],
    );
  }
}
