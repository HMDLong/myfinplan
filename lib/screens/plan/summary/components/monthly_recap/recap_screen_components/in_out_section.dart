import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/monthly_recap_screen.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/comment_card.dart';
import 'package:myfinplan/screens/plan/summary/components/monthly_recap/widgets/recap_section_title.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InOutSection extends ConsumerWidget {
  const InOutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data2 = [
      SummaryChartData("Dự kiến", [8000000, 7000000]),
      SummaryChartData("Thực tế", [9000000, 7500000]),
    ];
    return Column(
      children: [
        const RecapSectionTitle(title: "Thu chi"),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: SfCartesianChart(
            isTransposed: true,
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
            legend: const Legend(
              isVisible: true,
              isResponsive: true,
              position: LegendPosition.bottom,
            ),
            series: [
              ColumnSeries<SummaryChartData, String>(
                name: "Thu nhập",
                enableTooltip: true,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                width: 0.6,
                color: Colors.green.shade600,
                dataSource: data2,
                xValueMapper: (data, i) => data.x,
                yValueMapper: (data, i) => data.y[0],
              ),
              ColumnSeries<SummaryChartData, String>(
                name: "Chi phí",
                enableTooltip: true,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                width: 0.6,
                color: Colors.red.shade400,
                dataSource: data2,
                xValueMapper: (data, i) => data.x,
                yValueMapper: (data, i) => data.y[1],
              ),
            ],
          ),
        ),
        CommentCard(
          child: Wrap(
            children: [
              Text(
                "Trong tháng 4/2024, bạn chi tổng cộng ${Formatter.amountToDecimal(7500000)}, thu tổng cộng ${Formatter.amountToDecimal(12000000)}. Chi phí của bạn chiếm ${7500000 / 12000000 * 100} % tổng thu nhập.",
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
