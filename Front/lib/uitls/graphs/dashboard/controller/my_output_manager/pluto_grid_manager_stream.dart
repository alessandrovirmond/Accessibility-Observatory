import 'package:accessibility_audit/library/pluto_grid/src/manager/pluto_grid_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PlutoGridManagerOutput {

  final BehaviorSubject<String?> _rowChecked = BehaviorSubject();
  Stream<String?> get stream => _rowChecked.stream;
  Sink<String?> get sinkChecked => _rowChecked.sink;
  final Widget? info;
  final String key = DateTime.now().millisecondsSinceEpoch.toString();
  final PlutoGridStateManager Function() managerGrid;



  PlutoGridManagerOutput(   {required this.managerGrid,required this.info, }){
    _update(null);
  }

  _update(String? str){
    _rowChecked.sink.add(str);
  }
  
}