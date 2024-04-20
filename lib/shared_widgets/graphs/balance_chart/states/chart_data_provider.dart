import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/domain/transactions/transaction_notifier.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart/balance_chart.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart/states/chart_filter_provider.dart';

// class InitDetail {

// }

// final balanceChartDataProvider = FutureProvider.family<List<BalanceChartData>, String>((ref, syncId) async {
//   final filter = ref.watch(balanceChartFilterProvider(syncId));
//   final transacts = await ref.watch(transactionNotifierProvider).getAllTransaction();
//   // filter transactions
//   final filtered = transacts.where((e) {
//     return 
//   }).toList();
//   return [];
// },);