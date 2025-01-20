import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/models_graph.dart';

class ChartBarModel extends StatelessWidget {
  const ChartBarModel(
      {super.key,
      required this.model,
      required this.title,
      required this.keyChart,
      required this.peso,
      required this.total});

  final List<ModelGraph> model;
  final String title;
  final GlobalKey keyChart;
  final bool peso;
  final double total;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(

      plotAreaBorderWidth: 0,
     /*  title: ChartTitle(
        text:
          "$title \n Total: ${peso ? "${total / 100000} T" : "$total unidades"}",
          alignment: ChartAlignment.far), */
      legend: const Legend(isVisible: false),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(explicitSign: false),
      ),
      series: <BarSeries<ModelGraph, String>>[
        BarSeries<ModelGraph, String>(
          dataSource: model,
          xValueMapper: (ModelGraph snap, index) => snap.name,
          yValueMapper: (ModelGraph snap, index) =>
              peso ? snap.value / 100000 : snap.value,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
