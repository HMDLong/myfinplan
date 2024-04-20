import 'package:myfinplan/utils/time/times.dart';

enum DisplayValueMode { separated, accumulate }

enum DisplayContentType {
  balance,
  expense,
  income,
}

class BalanceChartFilterState {
  TimeRange timeRange;
  DisplayValueMode mode;
  DisplayContentType content;

  BalanceChartFilterState({
    required this.timeRange,
    required this.mode,
    required this.content,
  });

  BalanceChartFilterState.initial() : this.createWith();

  BalanceChartFilterState.createWith({
    TimeRange? range,
    DisplayValueMode? valueMode,
    DisplayContentType? contentType,
  })  : timeRange = range ?? TimeRange.rangeByType(TimeType.month),
        mode = valueMode ?? DisplayValueMode.separated,
        content = contentType ?? DisplayContentType.expense;

  BalanceChartFilterState copyWith({
    TimeRange? range,
    DisplayValueMode? valueMode,
    DisplayContentType? contentType,
  }) {
    return BalanceChartFilterState(
      timeRange: range ?? timeRange,
      mode: valueMode ?? mode,
      content: contentType ?? content,
    );
  }
}
