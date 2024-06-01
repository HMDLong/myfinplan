import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/shared_widgets/menu/menu.dart';
import 'package:myfinplan/screens/statistics/widgets/category_pie_chart/cate_piechart_state.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/constants/strings.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:myfinplan/utils/time/times.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryPieChart extends ConsumerStatefulWidget {
  final TimeRange timeRange;
  const CategoryPieChart({
    super.key,
    required this.timeRange,
  });

  @override
  ConsumerState<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends ConsumerState<CategoryPieChart> {
  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(chartFilterStateProvider);
    return ref.watch(categoryChartDataProvider(widget.timeRange)).when(
      data: (chartState) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thành phần thu chi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Thu chi của tôi cho những gì?",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                CustomMenu(
                  items: const [
                    DropdownMenuEntry(value: TransactionType.expense, label: "Chi phí"),
                    DropdownMenuEntry(value: TransactionType.income, label: "Thu nhập"),
                  ],
                  onChanged: (newValue) {
                    ref.read(chartFilterStateProvider.notifier).state = filterState.copyWith(
                      type: newValue,
                      categoryId: null,
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildRowLabel(chartState, filterState),
                _buildChart(chartState, filterState),
              ],
            ),
          ),
        );
      },
      error: (error, _) {
        return const Card(
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widgetErrorMessage),
              ],
            ),
          ),
        );
      },
      loading: () {
        return const Card(
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  _buildRowLabel(CategoryChartDataModel chartState, CategoryChartFilterState state) {
    if (chartState.data.isEmpty) {
      return const SizedBox(height: 1);
    }
    int spentAmount = chartState.data.fold(0, (prev, e) {
      return prev + e.y.toInt();
    });
    final label = categoryGroups[state.categoryId]?.name ?? "Tất cả";
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                amountToDecimal(spentAmount), // (${(spentAmount / totalAmount * 100).toStringAsFixed(2)} %)",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: state.categoryId != null,
              child: IconButton(
                onPressed: () {
                  if (state.categoryId != null) {
                    ref.read(chartFilterStateProvider.notifier).state = state.copyWith(categoryId: null);
                  }
                },
                icon: const Icon(CupertinoIcons.arrow_uturn_left),
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildChart(CategoryChartDataModel chartState, CategoryChartFilterState filterState) {
    if (chartState.data.isEmpty) {
      return const SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(noItemsMessage),
          ],
        ),
      );
    }
    int spentAmount = chartState.data.fold(0, (prev, e) {
      return prev + e.y.toInt();
    });
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: SfCircularChart(
        legend: const Legend(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10),
          position: LegendPosition.bottom,
          itemPadding: 10,
          shouldAlwaysShowScrollbar: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <CircularSeries>[
          DoughnutSeries<CategoryChartData, String>(
            radius: "50%",
            onPointTap: (pointInteractionDetails) {
              if (filterState.categoryId != null) {
                // If there is a parent id selected, do nothing
                return;
              }
              final i = pointInteractionDetails.pointIndex;
              if (i == null) {
                // Null-safe purpose
                log("CategoryPieChart: i = $i");
                return;
              }
              final detail = chartState.data[i];
              ref.read(chartFilterStateProvider.notifier).state = filterState.copyWith(
                categoryId: detail.categoryId,
              );
            },
            dataSource: chartState.data,
            xValueMapper: (CategoryChartData data, _) => data.x,
            yValueMapper: (CategoryChartData data, _) => data.y,
            explode: true,
            dataLabelSettings: const DataLabelSettings(
              showZeroValue: false,
              isVisible: true,
              textStyle: TextStyle(fontSize: 12, color: Colors.black),
              labelAlignment: ChartDataLabelAlignment.outer,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            legendIconType: LegendIconType.circle,
            dataLabelMapper: (datum, index) => "${datum.x} (${(datum.y * 100 / spentAmount).round()}%)",
          )
        ],
      ),
    );
  }
}
