import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/models_graph.dart';

class PyramidChartModel extends StatelessWidget {
  const PyramidChartModel(
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
    return SfPyramidChart(

        onTooltipRender: (TooltipArgs args) {
        },
        //  smartLabelMode: SmartLabelMode.none,
       /*  title: ChartTitle(
            text:
                "$title \n Total: ${peso ? "${total / 100000} T" : "$total unidades"}",
            alignment: ChartAlignment.far), */
        legend:
            const Legend(isVisible: false, overflowMode: LegendItemOverflowMode.wrap),

        /// To enable the legend for pyramid.
        /// And to cusmize the legend options here.
        tooltipBehavior: TooltipBehavior(enable: true),
        series: PyramidSeries<ModelGraph, String>(
            dataSource: model,
            xValueMapper: (ModelGraph snap, index) => snap.name,
            yValueMapper: (ModelGraph snap, index) =>
                peso ? snap.value / 100000 : snap.value,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              showCumulativeValues: false,

              //    labelPosition: ChartDataLabelPosition.inside
            )));
  }
}
