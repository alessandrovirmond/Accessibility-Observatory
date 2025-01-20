import 'package:accessibility_audit/library/pluto_grid/pluto_grid_plus.dart';
import 'package:accessibility_audit/library/pluto_grid/src/helper/filtered_list.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';
import 'package:flutter/material.dart';
import '../generator_dashboard.dart';

class GeneratorDashboardController {
  Widget addApp(FilteredList<PlutoColumn> collumns, FilteredList<PlutoRow> rows,
      BuildContext context,) {
    List<String> collumValues = [];
    List<String> collumNumbers = [];
    for (var element in collumns) {
      collumValues.add(element.title);
      if (element.type.isNumber) {
        collumNumbers.add(element.title);
      }
    }

 
       return 
       
       
       GeneratorDashboard(
          collumns: collumValues, row: rows, collumnsNumber: collumNumbers);
        
    
  }
}
