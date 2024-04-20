import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/shared_widgets/graphs/balance_chart/states/chart_filter_state.dart';

final balanceChartFilterProvider = StateProvider.family<BalanceChartFilterState, String>((ref, syncId) {
  return BalanceChartFilterState.initial();
});
