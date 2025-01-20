import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/library/pluto_grid/src/manager/pluto_grid_state_manager.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column_type.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';
import 'package:accessibility_audit/library/pluto_grid/src/plugin/pluto_aggregate_column_footer.dart';
import 'package:accessibility_audit/library/pluto_grid/src/pluto_grid_events.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';
import 'package:accessibility_audit/report/controller/i_report_controller.dart';
import 'package:accessibility_audit/report/model/domain_model.dart';
import 'package:accessibility_audit/report/repository/domain_repository.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';

class DomainController implements IReportController {
  final DomainRepository _repository = DomainRepository();
  int selected = -1;
  PlutoGridStateManager? stateManager;

  // ValueNotifier para o evento do grafico ser gerado
  @override
  final ValueNotifier<bool> isGraphActive = ValueNotifier<bool>(false);

  // ValueNotifier para o evento do botão
  @override
  final ValueNotifier<int?> isButtonPressed = ValueNotifier<int?>(null);

  Future<List<PlutoRow>> getRows({required int id}) async {
    isGraphActive.value = false;

    final List<DomainModel> response = await _repository.get();

    return response.map((r) => r.toRow()).toList();
  }

  List<PlutoColumn> getCollumnsReport(
      {required void setReport(
          {required EnumReport enumReport, required int id, required String label})}) {
    return [
      PlutoColumn(
        title: "",
        field: "E",
        width: 60,
        enableColumnDrag: false,
        enableDropToResize: false,
        enableSetColumnsMenuItem: false,
        enableSorting: false,
        enableFilterMenuItem: false,
        enableAutoEditing: false,
        enableEditingMode: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return IconButton(
            onPressed: () {
              final String value = rendererContext.cell.value;
              final List<String> list = value.split("*&*");
              final int? id = int.tryParse(list[0]); 

              setReport(id: id ?? 0, enumReport: EnumReport.page, label: list[1]);

              // Recarrega o ReportPage chamando o setState
              rendererContext.stateManager.notifyListeners();
            },
            icon: Icon(
              Icons.list,
              color: PalleteColor.blue,
            ),
          );
        },
      ),
   
      PlutoColumn(
          title: "Domínio",
          field: "Domínio",
          type: PlutoColumnType.text(),
          width: 180),
      PlutoColumn(
          title: "Nota do Domínio",
          field: "Nota do Domínio",
          type: PlutoColumnType.number(locale: "pt_Br", format: "#,##0.00"),
          width: 180),
           PlutoColumn(
          title: "Total de Páginas",
          field: "Total de Páginas",
          type: PlutoColumnType.number(locale: "pt_Br"),
          width: 180,
          footerRenderer: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.sum,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.average,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Média: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
            ],
          );
        },),
      PlutoColumn(
          title: 'Total de Violações',
          field: 'Total de Violações',
          type: PlutoColumnType.number(locale: "pt_Br"),
          width: 180,
          footerRenderer: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.sum,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.average,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Média: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
            ],
          );
        },
          ),
      PlutoColumn(
          title: 'Média de Violações por Página',
          field: 'Média de Violações por Página',
          type: PlutoColumnType.number(locale: "pt_Br"),
          width: 180,
          footerRenderer: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.sum,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.average,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Média: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
            ],
          );
        },
        ),
      PlutoColumn(
          title: 'Média de Elementos Afetados por Página',
          field: 'Média de Elementos Afetados por Página',
          type: PlutoColumnType.number(locale: "pt_Br"),
          width: 180,
          footerRenderer: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.sum,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
              PlutoAggregateColumnFooter(
                rendererContext: context,
                formatAsCurrency: false,
                type: PlutoAggregateColumnType.average,
                alignment: Alignment.center,
                titleSpanBuilder: (text) {
                  return [
                    const TextSpan(
                      text: 'Média: ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                        text:
                           text),
                  ];
                },
              ),
            ],
          );
        },),
    
    ];
  }
}
