import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/models_graph.dart';

class PieModelChart extends StatelessWidget {
  const PieModelChart(
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

    return SfCircularChart(
      key: keyChart,

    /*   title: ChartTitle(
          text:
              "$title \n Total: ${peso ? "${total / 100000} T" : "$total unidades"}",
          alignment: ChartAlignment.far), */
      series: <PieSeries<ModelGraph, String>>[
        
        PieSeries<ModelGraph, String>(

            dataSource: model,
            xValueMapper: (snap, index) => snap.name,
            yValueMapper: (snap, index) =>
                peso ? snap.value / 100000 : snap.value,
            dataLabelMapper: (snap, index) => peso
                ? "${snap.name} : \n${snap.value / 100000} T"
                : "${snap.name} : \n${snap.value}",
            explodeAll: true,
            dataLabelSettings: const DataLabelSettings(
            
                margin: EdgeInsets.zero,
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: ConnectorLineSettings(
                  
                    type: ConnectorType.curve, length: '10%'),
                labelIntersectAction: LabelIntersectAction.shift)),
      ],
      tooltipBehavior: TooltipBehavior(),
    );
  }
}