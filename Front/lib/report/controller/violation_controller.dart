import 'package:accessibility_audit/library/pluto_grid/src/manager/pluto_grid_state_manager.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column_type.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';
import 'package:accessibility_audit/library/pluto_grid/src/plugin/pluto_aggregate_column_footer.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';
import 'package:accessibility_audit/report/controller/i_report_controller.dart';
import 'package:accessibility_audit/report/model/violation_model.dart';
import 'package:accessibility_audit/report/repository/violation_repository.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViolationController implements IReportController {
  final ViolationRepository _repository = ViolationRepository();
  int selected = -1;
  PlutoGridStateManager? stateManager;

  // ValueNotifier para o evento do gráfico ser gerado
  @override
  final ValueNotifier<bool> isGraphActive = ValueNotifier<bool>(false);

  // ValueNotifier para o evento do botão
  @override
  final ValueNotifier<int?> isButtonPressed = ValueNotifier<int?>(null);

  /// Busca os dados e converte para linhas no grid
  Future<List<PlutoRow>> getRows({required int id}) async {
    isGraphActive.value = false;

    final List<ViolationModel> response = await _repository.get(id: id);

    return response.map((r) => r.toRow()).toList();
  }

  /// Define as colunas do grid para o relatório de violações
  List<PlutoColumn> getCollumnsReport({
    required void setReport({
      required EnumReport enumReport,
      required String label,
      required int id
    }),
  }) {
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

              setReport(id: id ?? 0, enumReport: EnumReport.elements, label: list[1]);

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
        title: "Violação",
        field: "Violação",
        type: PlutoColumnType.text(),
        width: 200,
          footerRenderer: (context) => PlutoAggregateColumnFooter(
          rendererContext: context,
          formatAsCurrency: false,
          type: PlutoAggregateColumnType.count,
          alignment: Alignment.center,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'QNT:  ',
                style: TextStyle(color: Colors.red),
              ),
              TextSpan(text: text.replaceAll('\$', "").replaceAll(",", ".")),
            ];
          },
        ),
      ),
       PlutoColumn(
        title: "Nível de Impacto",
        field: "Nível de Impacto",
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: "Regra Violada",
        field: "Regra Violada",
        type: PlutoColumnType.text(),
        width: 180,
      ),
       PlutoColumn(
        title: "Elementos Afetados",
        field: "Elementos Afetados",
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
                    TextSpan(text: text),
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
                    TextSpan(text: text),
                  ];
                },
              ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: "Como Corrigir",
        field: "Como Corrigir",
        type: PlutoColumnType.text(),
        width: 250,
      ),
      PlutoColumn(
        title: "Mais Informações",
        field: "Mais Informações",
        type: PlutoColumnType.text(),
        width: 250,
        renderer: (rendererContext) {
          final String link = rendererContext.cell.value;
          return InkWell(
            onTap: () {
              // Abre o link em um navegador
              // Exemplo de lógica usando url_launcher
              launchUrl(Uri.parse(link));
            },
            child: Text(
              link,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          );
        },
      ),
     
     
    
    ];
  }
}
