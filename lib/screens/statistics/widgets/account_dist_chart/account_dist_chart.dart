import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinplan/data/models/account/account.dart';
import 'package:myfinplan/screens/home/components/account_summary_section.dart';
import 'package:myfinplan/utils/format.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef DoughnutChartData = ({String x, int y});

class AccountDistributionChart extends ConsumerWidget {
  const AccountDistributionChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              "Thành phần số dư",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Số dư của tôi gồm những thành phần nào?",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ref.watch(balanceSummaryProvider).when(
                    data: (data) {
                      final chartData = <DoughnutChartData>[
                        (x: "Tiền mặt", y: data[AccountType.cash] ?? 0),
                        (x: "Ví", y: data[AccountType.debit] ?? 0),
                        (x: "Tín dụng", y: data[AccountType.credit] ?? 0),
                        (x: "Tiết kiệm", y: data[AccountType.saving] ?? 0),
                      ];
                      final total = data.values.fold(0, (prev, e) => prev + e);
                      return SfCircularChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: Legend(
                          isVisible: true,
                          isResponsive: true,
                          position: LegendPosition.right,
                          alignment: ChartAlignment.far,
                          legendItemBuilder: (legendText, series, point, seriesIndex) {
                            final point_ = point;
                            final chartPoint = point_ as ChartPoint;
                            // log(series[seriesIndex]);
                            return SizedBox(
                              height: 40,
                              width: 120,
                              child: Row(
                                children: [
                                  Icon(
                                    Boxicons.bx_pie_chart,
                                    color: chartPoint.color,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        legendText,
                                        style: TextStyle(color: Colors.black, fontSize: 10),
                                      ),
                                      Text(
                                        "${Formatter.amountToCompact(point.y, currency: null)} (${(point.y * 100 / total).round()}%)",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        series: [
                          DoughnutSeries<DoughnutChartData, String>(
                            radius: "80%",
                            dataSource: chartData,
                            xValueMapper: (value, i) => value.x,
                            yValueMapper: (value, i) => value.y,
                          ),
                        ],
                      );
                    },
                    error: (error, _) => Text("$error"),
                    loading: () => const CircularProgressIndicator(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
