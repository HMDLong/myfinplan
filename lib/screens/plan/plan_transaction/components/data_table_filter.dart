import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataTableFilterProvider = StateProvider((ref) => DataTableFilterState.init());

class DataTableFilterState {
  bool sorted;
  DataCol sortField;
  bool ascending;

  DataTableFilterState({
    required this.sorted,
    required this.sortField,
    required this.ascending,
  });

  DataTableFilterState.init()
      : sorted = false,
        sortField = DataCol.actual,
        ascending = false;

  DataTableFilterState copyWith({
    bool? sorted,
    DataCol? sortField,
    bool? ascending,
  }) {
    return DataTableFilterState(
      sorted: sorted ?? this.sorted,
      sortField: sortField ?? this.sortField,
      ascending: ascending ?? this.ascending,
    );
  }
}

enum DataCol {
  label,
  plan,
  actual,
  difference,
}
