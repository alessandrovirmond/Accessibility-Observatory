// Define a interface que os controladores devem implementar
import 'package:accessibility_audit/library/pluto_grid/src/manager/pluto_grid_state_manager.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';
import 'package:flutter/material.dart';

abstract class IReportController {

  int get selected;
  set selected(int value);

  PlutoGridStateManager? get stateManager;
  set stateManager(PlutoGridStateManager? manager);

  ValueNotifier<bool> get isGraphActive;
  ValueNotifier<int?> get isButtonPressed;

  Future<List<PlutoRow>> getRows({required int id});

List<PlutoColumn> getCollumnsReport({
    required void setReport({
      required EnumReport enumReport,
      required int id,
      required String label,
    }),
  });}
