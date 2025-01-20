import 'package:accessibility_audit/library/pluto_grid/src/manager/pluto_grid_state_manager.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column_type.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';
import 'package:accessibility_audit/library/pluto_grid/src/plugin/pluto_aggregate_column_footer.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';
import 'package:accessibility_audit/report/controller/i_report_controller.dart';
import 'package:accessibility_audit/report/model/element_model.dart';
import 'package:accessibility_audit/report/repository/element_repository.dart';
import 'package:flutter/material.dart';


class ElementController implements IReportController {
  final ElementRepository _repository = ElementRepository();
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

    final List<ElementModel> response = await _repository.get(id: id);

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
        title: "Elemento HTML",
        field: "Elemento HTML",
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
        title: "Seletores",
        field: "Seletores",
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: "Contexto",
        field: "Contexto",
        type: PlutoColumnType.text(),
        width: 180,
      ),
     
    
    ];
  }
}
