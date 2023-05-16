import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Sfchart extends StatelessWidget {
  const Sfchart({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(isVisible: false),
        //  primaryYAxis: CategoryAxis(isVisible: false),
        series: <ChartSeries>[
          // Renders spline chart
          SplineSeries<ChartData, int>(
              color: Colors.yellow,
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ]);
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double? y;
}
