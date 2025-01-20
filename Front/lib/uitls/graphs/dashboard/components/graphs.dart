import 'package:accessibility_audit/uitls/graphs/dashboard/models/enum_graph_style.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/models/model_selector_graph.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/models/models_graph.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/pages/graphs/model_graph_chart_bar.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/pages/graphs/model_graph_pie.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/pages/graphs/model_graph_pyramid.dart';
import 'package:flutter/material.dart';


class GraphSelectorWidget extends StatelessWidget {
  final double t;
  final List<ModelGraph> model;
  const GraphSelectorWidget({super.key, required this.t, required this.model});
  static GlobalKey dash = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double total = t.toDouble();

    switch (ModelSelectorGraph.graph) {
      case GraphStyle.pie:
        return PieModelChart(
            peso: false, title: "", model: model, keyChart: dash, total: total);

      case GraphStyle.pyramid:
        return PyramidChartModel(
            peso: false, title: "", model: model, keyChart: dash, total: total);

      case GraphStyle.bar:
        return ChartBarModel(
            peso: false, title: "", model: model, keyChart: dash, total: total);

      default:
        return const SizedBox.shrink();
    }
  }
}
