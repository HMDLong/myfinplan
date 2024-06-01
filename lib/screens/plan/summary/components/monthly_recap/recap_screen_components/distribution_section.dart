import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/data/models/category/transaction_type.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/providers/providers.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/comment_card.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/recap_section_title.dart';
import 'package:myfinplan/shared_widgets/menu/menu.dart';
import 'package:myfinplan/utils/constants/predefined_categories.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DistributionSection extends ConsumerStatefulWidget {
  const DistributionSection({super.key});

  @override
  ConsumerState<DistributionSection> createState() => _DistributionSectionState();
}

class _DistributionSectionState extends ConsumerState<DistributionSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RecapSectionTitle(title: "Phân phối thu chi"),
        const SizedBox(height: 10),
        CustomMenu<TransactionType>(
          items: const [
            DropdownMenuEntry(value: TransactionType.expense, label: "Chi phí"),
            DropdownMenuEntry(value: TransactionType.income, label: "Thu nhập"),
          ],
          onChanged: (value) {
            ref.read(selectedTransactTypeProvider.notifier).state = value;
            ref.read(selectedParentCategoryProvider.notifier).state = null;
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final selectedParent = ref.watch(selectedParentCategoryProvider);
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    categoryGroups[selectedParent]?.name ?? "Tất cả",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (selectedParent != null)
                  SizedBox(
                    width: 30,
                    child: IconButton(
                      onPressed: () {
                        ref.read(selectedParentCategoryProvider.notifier).state = null;
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(
          height: 350,
          width: double.infinity,
          child: ref.watch(selectedCategoryDetailProvider).when(
                data: (details) {
                  final selectedParent = ref.watch(selectedParentCategoryProvider);
                  return SfCartesianChart(
                    isTransposed: true,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    onAxisLabelTapped: (axisLabelTapArgs) {
                      if (selectedParent != null) {
                        return;
                      }
                      for (var detail in details) {
                        if (detail.label == axisLabelTapArgs.text) {
                          ref.read(selectedParentCategoryProvider.notifier).state = detail.id;
                        }
                      }
                    },
                    primaryXAxis: CategoryAxis(
                      labelIntersectAction: AxisLabelIntersectAction.rotate90,
                      labelStyle: selectedParent == null
                          ? const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            )
                          : null,
                    ),
                    primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
                    legend: const Legend(
                      isVisible: true,
                      isResponsive: true,
                      position: LegendPosition.bottom,
                    ),
                    series: [
                      ColumnSeries<ChartData, String>(
                        name: "Thực tế",
                        enableTooltip: true,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        color: Colors.indigo.shade900,
                        dataSource: details,
                        xValueMapper: (data, i) => data.label,
                        yValueMapper: (data, i) => data.actual,
                      ),
                      ColumnSeries<ChartData, String>(
                        name: "Dự kiến",
                        enableTooltip: true,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        color: Colors.blue.shade300,
                        dataSource: details,
                        xValueMapper: (data, i) => data.label,
                        yValueMapper: (data, i) => data.plan,
                      ),
                    ],
                  );
                },
                error: (error, _) => Column(
                  children: [
                    Text("$error"),
                  ],
                ),
                loading: () => const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
        ),
        CommentCard(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Đây là tháng thứ 2 liên tiếp số dư tăng trưởng. Từ tháng 3/2024 (${amountToDecimal(100000000)}) đã tăng ${amountToDecimal(120530000 - 100000000)} (+20.53%).",
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final String id;
  final String label;
  final int plan;
  final int actual;

  ChartData(this.id, this.label, this.plan, this.actual);
}
