import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AccountDistributionChart extends ConsumerWidget {
  const AccountDistributionChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = [];
    return SfCircularChart(
      series: [
        DoughnutSeries(
          dataSource: data,
          xValueMapper: (value, i) {},
          yValueMapper: (value, i) {},
        ),
      ],
    );
  }
}
