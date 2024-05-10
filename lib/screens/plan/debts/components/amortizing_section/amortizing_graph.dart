import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AmortizingGraph extends StatefulWidget {
  const AmortizingGraph({super.key});

  @override
  State<AmortizingGraph> createState() => _AmortizingGraphState();
}

class _AmortizingGraphState extends State<AmortizingGraph> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        series: [
          SplineSeries<LineChartData, String>(
            name: "Balance",
            color: Colors.black,
            dataSource: [],
            xValueMapper: (data, i) => data.x,
            yValueMapper: (data, i) => data.y,
          ),
          SplineSeries<LineChartData, String>(
            name: "Interest",
            color: const Color.fromARGB(255, 53, 62, 190),
            dataSource: [],
            xValueMapper: (data, i) => data.x,
            yValueMapper: (data, i) => data.y,
          ),
          SplineSeries<LineChartData, String>(
            name: "Principal",
            color: Colors.green,
            dataSource: [],
            xValueMapper: (data, i) => data.x,
            yValueMapper: (data, i) => data.y,
          ),
        ],
      ),
    );
  }
}

class LineChartData {
  String x;
  double y;

  LineChartData(this.x, this.y);
}
