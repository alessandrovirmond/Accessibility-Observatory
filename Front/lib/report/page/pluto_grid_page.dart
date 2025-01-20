import 'dart:async';
import 'package:accessibility_audit/library/pluto_grid/src/helper/filter_helper.dart';
import 'package:accessibility_audit/library/pluto_grid/src/manager/event/pluto_grid_change_column_filter_event.dart';
import 'package:accessibility_audit/library/pluto_grid/src/manager/event/pluto_grid_event.dart';
import 'package:accessibility_audit/library/pluto_grid/src/manager/pluto_grid_state_manager.dart';
import 'package:accessibility_audit/library/pluto_grid/src/manager/shortcut/pluto_grid_shortcut.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';
import 'package:accessibility_audit/library/pluto_grid/src/pluto_grid.dart';
import 'package:accessibility_audit/library/pluto_grid/src/pluto_grid_configuration.dart';
import 'package:accessibility_audit/library/pluto_grid/src/pluto_grid_events.dart';
import 'package:accessibility_audit/report/controller/i_report_controller.dart';
import 'package:accessibility_audit/uitls/do_print/do_print.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/components/controller/generator_dashboard.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/controller/my_output_manager/pluto_grid_manager_stream.dart';
import 'package:accessibility_audit/report/page/plutto_options/filters/not_contains.dart';
import 'package:accessibility_audit/report/page/plutto_options/plutto_options.dart';
import 'package:accessibility_audit/uitls/converter/date_parse_format.dart';
import 'package:accessibility_audit/uitls/global_pages_utils/loading/global_page_loading.dart';
import 'package:accessibility_audit/uitls/global_pages_utils/loading/global_page_loading_percent.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:accessibility_audit/uitls/graphs/my_line_chart.dart';
import 'package:flutter/material.dart';

class PlutoGridExamplePage extends StatefulWidget {
  final Future<List<PlutoRow>> futureRow;
  final List<PlutoColumn> collumn;
  final Stream<int>? percent;
  final String? title;
  final Widget? info;
  IReportController controller;
  PlutoGridStateManager? stateManager;

  static bool updateWindows = false;
  static late BuildContext reportContext;
  PlutoGridExamplePage({
    super.key,
    required this.futureRow,
    required this.collumn,
    this.percent,
    this.title,
    this.info,
    required this.controller,
    this.stateManager,
  
  });

  @override
  State<PlutoGridExamplePage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<PlutoGridExamplePage> {
  bool isDark = false;
  bool pdfPressed = false;
  bool csvPressed = false;
  bool exelPressed = false;
  late final StreamSubscription<PlutoGridEvent> events;
  late PlutoGridManagerOutput output;

  List<PlutoGridChangeColumnFilterEvent> filters = [];

  GeneratorDashboardController generate = GeneratorDashboardController();

  @override
  Widget build(BuildContext context) {
    output = PlutoGridManagerOutput(
      info: widget.info,
      managerGrid: manage,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FutureBuilder(
            future: widget.futureRow,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return GlobalPageLoadingPercent(percent: widget.percent);
              }
              return PlutoGrid(
                columns: widget.collumn,
                rows: snap.data!,
                onRowChecked: (row) {},
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  widget.controller.stateManager = event.stateManager;
                  widget.stateManager = event.stateManager;
                  widget.stateManager!.setShowColumnFilter(true);
                },
                configuration: PlutoGridConfiguration(
                  columnSize: PlutoGridColumnSizeConfig(),
                  columnFilter: PlutoGridColumnFilterConfig(
                    filters: [
                      const PlutoFilterTypeContains(),
                      const PlutoFilterTypeGreaterThanOrEqualTo(),
                      const PlutoFilterTypeEndsWith(),
                      const PlutoFilterTypeLessThanOrEqualTo(),
                      const PlutoFilterTypeStartsWith(),
                      NotContains(),
                    ],
                  ),
                  shortcut: PlutoGridShortcut(actions: MyPlutoOptions.shortcut),
                  style: const PlutoGridStyleConfig(
                    gridBackgroundColor: PalleteColor.scaffold,
                    oddRowColor: PalleteColor.scaffold,
                    evenRowColor: PalleteColor.scaffold,
                    rowColor: PalleteColor.scaffold,
                    activatedColor: Colors.transparent, 
                    filterHeaderColor: PalleteColor.scaffold,
                    filterHeaderIconColor: PalleteColor.scaffold,
                    enableGridBorderShadow: false,
                    gridBorderColor: PalleteColor.scaffold,

                    columnTextStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    rowCheckedColor: PalleteColor.red,
                  ),
                  localeText: const PlutoGridLocaleText(
                    unfreezeColumn: "Descongelar",
                    freezeColumnToEnd: "Congelar no Final",
                    freezeColumnToStart: "Congelar no Inicio",
                    filterEndsWith: "Filtro Terminado em:",
                    hideColumn: "Esconder Colunas",
                    setColumns: "Modificar Colunas",
                    setFilter: "Setar Filtros",
                    setColumnsTitle: "Setar Nome da Coluna",
                    filterStartsWith: "Filtros Começados em:",
                    filterAllColumns: "Filtros em Todas as Colunas",
                    filterColumn: "Filtro de Coluna",
                    filterContains: "Contém",
                    filterValue: "Valor",
                    filterEquals: "Igual",
                    filterGreaterThan: "Maior que",
                    filterGreaterThanOrEqualTo: "Maior ou igual que",
                    filterLessThan: "Menor que",
                    filterLessThanOrEqualTo: "Menor ou igual que",
                    filterType: "Tipo",
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder<int?>(
            valueListenable: widget.controller.isButtonPressed,
            builder: (context, millisecond, child) {
              return millisecond != null
                  ? Positioned(
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.62,
                        height: MediaQuery.of(context).size.height * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: PalleteColor.red, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 30,
                              child: Text(
                                "Dia ${DateParseFormat.formatMilliseconds(millisecond)}",
                                style: MyStyles.subBoldBlack,
                              ),
                            ),
                            Expanded(
                              child: MyLineChart(
                                key: ValueKey(millisecond),
                                milliscond: millisecond,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: widget.controller.isGraphActive,
            builder: (context, isPressed, child) {

             
              return isPressed
                  ? Center(
                      child: generate.addApp(
                        output.managerGrid().refColumns,
                        output.managerGrid().refRows,
                        context,
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  PlutoGridStateManager manage() => widget.stateManager!;
}
