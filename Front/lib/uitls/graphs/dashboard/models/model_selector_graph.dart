

import 'enum_graph_style.dart';

class ModelSelectorGraph {
  static GraphStyle graph = GraphStyle.pie;
  final String title;
  final Function model;
  final bool peso;

  ModelSelectorGraph(this.title, this.model, this.peso);
}
