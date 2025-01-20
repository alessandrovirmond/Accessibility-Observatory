

import '../models/enum_graph_style.dart';
import '../models/model_selector_graph.dart';
import '../models/models_graph.dart';

class DashboardController{

  

  final List<ModelSelectorGraph> select;
  final Function update;

  
  
  GraphStyle style = GraphStyle.pie;
  int selecter = 0;

  Future<List<ModelGraph>> get  modelsList => select[selecter].model();
  bool get peso =>select[selecter].peso;


  String get  modelsTitle => select[selecter].title;
  set selecterGraph (int index) {
    selecter = index;
    update();
  }


  DashboardController(this.select, {required this.update});




}