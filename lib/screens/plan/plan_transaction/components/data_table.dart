import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/screens/plan/plan_transaction/components/data_table_filter.dart';
import 'package:myfinplan/screens/plan/plan_transaction/plan_transact_tab.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/format.dart';

const headerStyle = TextStyle(fontSize: 12);
const dataStyle = TextStyle(fontSize: 12);

class ExpandableDataTable extends ConsumerStatefulWidget {
  final List<PlanTransactDetail> data;
  const ExpandableDataTable({super.key, required this.data});

  @override
  ConsumerState<ExpandableDataTable> createState() => _ExpandableDataTableState();
}

class _ExpandableDataTableState extends ConsumerState<ExpandableDataTable> {
  final cols = [
    const DropdownMenuEntry(value: DataCol.label, label: ""),
    const DropdownMenuEntry(value: DataCol.plan, label: "Dự tính"),
    const DropdownMenuEntry(value: DataCol.actual, label: "Thực tế"),
    const DropdownMenuEntry(value: DataCol.difference, label: "Chênh lệch"),
  ];

  _buildRow(Widget col1, Widget col2, Widget col3, Widget col4) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(child: Align(alignment: Alignment.centerLeft, child: col1)),
          Expanded(child: Align(alignment: Alignment.centerRight, child: col2)),
          Expanded(child: Align(alignment: Alignment.centerRight, child: col3)),
          Expanded(child: Align(alignment: Alignment.centerRight, child: col4)),
        ],
      ),
    );
  }

  _buildHeader(DataTableFilterState sortState) {
    final headerCols = cols.map(
      (e) {
        if (e.value == DataCol.label) {
          return InputChip(
            avatar: Icon(
              Icons.refresh,
              size: 14,
              color: sortState.sorted ? Colors.black : Colors.transparent,
            ),
            label: Text(sortState.sorted ? "Đặt lại" : "", style: headerStyle),
            backgroundColor: sortState.sorted ? Colors.blue.shade50 : Colors.transparent,
            onPressed: () {
              if (sortState.sorted) {
                ref.read(dataTableFilterProvider.notifier).state = sortState.copyWith(sorted: false);
              }
            },
          );
        }
        return InputChip(
          labelPadding: EdgeInsets.zero,
          selected: sortState.sorted && sortState.sortField == e.value,
          selectedColor: Colors.blue.shade50,
          showCheckmark: false,
          avatar: !sortState.sorted
              ? null
              : sortState.sortField != e.value
                  ? null
                  : sortState.ascending
                      ? const Icon(Icons.arrow_upward, size: 14)
                      : const Icon(Icons.arrow_downward, size: 14),
          label: Text(e.label, style: headerStyle),
          onPressed: () {
            if (e.value == DataCol.label) return;
            final newState = !sortState.sorted
                ? sortState.copyWith(sorted: true, sortField: e.value, ascending: false)
                : sortState.sortField == e.value
                    ? sortState.copyWith(ascending: !sortState.ascending)
                    : sortState.copyWith(sortField: e.value);
            ref.read(dataTableFilterProvider.notifier).state = newState;
          },
          backgroundColor: Colors.transparent,
        );
      },
    ).toList();
    return _buildRow(headerCols[0], headerCols[1], headerCols[2], headerCols[3]);
  }

  Widget _buildItemRow(String label, int plan, int actual, {bool hasButton = false}) {
    return _buildRow(
      hasButton
          ? ExpandableButton(
              child: Chip(
                backgroundColor: Colors.blue.shade50,
                labelPadding: const EdgeInsets.only(right: 4),
                avatar: const Icon(Icons.arrow_drop_down, size: 14),
                label: Text(label, style: dataStyle),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(label, style: dataStyle),
            ),
      Text(amountToDecimal(plan, currency: null), style: dataStyle),
      Text(amountToDecimal(actual, currency: null), style: dataStyle),
      Text(amountToDecimal(actual - plan, currency: null), style: dataStyle),
    );
  }

  List<Widget> _buildItems(DataTableFilterState sortState) {
    // if sorted, show all children categories without grouping by parent
    if (sortState.sorted) {
      final sorted = widget.data
        ..sort((a, b) {
          int x, y;
          switch (sortState.sortField) {
            case DataCol.actual:
              x = a.actual;
              y = b.actual;
              break;
            case DataCol.plan:
              x = a.plan;
              y = b.plan;
              break;
            case DataCol.difference:
              x = a.actual - a.plan;
              y = b.actual - b.plan;
              break;
            case DataCol.label:
              x = a.actual;
              y = b.actual;
              break;
          }
          if (sortState.ascending) {
            return x.compareTo(y);
          }
          return y.compareTo(x);
        });
      return sorted.map((e) {
        return _buildItemRow(e.category.name, e.plan, e.actual);
      }).toList();
    }
    // if not sorting, group by parent for better view
    final res = <Widget>[];
    final groupsByParent = widget.data.fold(<String, List<PlanTransactDetail>>{}, (prev, e) {
      prev.putIfAbsent(e.category.parentId, () => []);
      prev[e.category.parentId]?.add(e);
      return prev;
    });
    for (var group in groupsByParent.entries) {
      final parent = categoryGroups[group.key]!;
      final totals = group.value.fold([0, 0], (prev, e) {
        prev[0] += e.actual;
        prev[1] += e.plan;
        return prev;
      });
      final widget = ExpandableNotifier(
        child: ScrollOnExpand(
          child: Expandable(
            collapsed: _buildItemRow(parent.name, totals[1], totals[0], hasButton: true),
            expanded: Column(
              children: [
                ...group.value.map((e) {
                  return _buildItemRow(e.category.name, e.plan, e.actual);
                }).toList(),
                ExpandableButton(
                  child: const Text("back"),
                ),
              ],
            ),
          ),
        ),
      );
      res.add(widget);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final sortState = ref.watch(dataTableFilterProvider);
    return Column(
      children: [
        _buildHeader(sortState),
        ..._buildItems(sortState),
      ],
    );
  }
}
