import 'dart:convert';

import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/library/pluto_grid_export/src/pluto_grid_plus_export.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';
import 'package:accessibility_audit/report/controller/i_report_controller.dart';
import 'package:accessibility_audit/report/page/components/button_data.dart';
import 'package:accessibility_audit/report/page/components/button_export.dart';
import 'package:accessibility_audit/report/page/components/button_report.dart';
import 'package:accessibility_audit/report/page/components/button_top_menu.dart';
import 'package:accessibility_audit/report/page/components/button_top_menu_model.dart';
import 'package:accessibility_audit/report/page/components/export_services/export_pluto_grid.dart';
import 'package:accessibility_audit/report/repository/state_repository.dart';
import 'package:accessibility_audit/services/file_save/save_file.dart';
import 'package:flutter/material.dart';
import 'package:accessibility_audit/report/controller/domain_contoller.dart';
import 'package:accessibility_audit/report/page/pluto_grid_page.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late IReportController controller;
  final StateRepository stateRepo = StateRepository();
  List<String> estados = ["Todos"]; 
  bool isLoading = true;

  // Função para pegar os estados e preencher a lista
  Future<void> _getEstados() async {
    try {
     
      List<String> estadosObtidos = await stateRepo.get();
      setState(() {
        
        estados = ["Todos"] + estadosObtidos;
         isLoading = false;
      });
    } catch (e) {
       setState(() {
        isLoading = false;
      });
      print('Erro ao buscar estados: $e');
     
    }
  }

  
  void setEstado(String estado) {
    setState(() {
      Config.estado = estado;
      Config.enumReport = EnumReport.domain;
      Config.listButton.clear();
       controller = Config.enumReport.controller;
      
    });
    _reloadReport();
  }

  @override
  initState() {
    controller = Config.enumReport.controller;
    _getEstados();
    super.initState();
  }

  void _reloadReport() {
    setState(() {});
  }

  void setReport({
    required EnumReport enumReport,
    required String label,
    required int id,
    bool add = true,
  }) {


    Config.enumReport = enumReport;
    Config.id = id;

        // Tratamento para remover ocorrências específicas do label
    final treatedLabel = label
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .replaceAll('www.', '')
        .replaceAll('.rj.gov.br', '');

    if (add) {
      Config.listButton
          .add(ButtonData(label: treatedLabel, id: id, enumReport: enumReport));
    }

    controller = Config.enumReport.controller;
    _reloadReport();
  }

  @override
  Widget build(BuildContext context) {
    final double hg = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;

      if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 300, // Limita a largura máxima do botão
                      maxHeight: 50, // Altura mínima
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(5, 5),
                        )
                      ],
                    ),
                    child: DropdownButton<String>(
                      underline: SizedBox.shrink(),
                      value: Config.estado.isNotEmpty ? Config.estado : "Todos",
                      items: estados.map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setEstado(newValue); 
                        }
                      },
                    ),
                  ),
                  Row(
                    children: Config.listButton.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final ButtonData buttonData = entry.value;
                      final bool isLast = index == Config.listButton.length - 1;

                      return Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          ButtonReport(
                            data: buttonData,
                            callback: () {
                              if (isLast) {
                                setReport(
                                    add: false,
                                    enumReport: buttonData.enumReport,
                                    label: buttonData.label,
                                    id: buttonData.id);
                              } else {
                                Config.listButton.removeRange(
                                    index + 1, Config.listButton.length);
                                setReport(
                                    add: false,
                                    enumReport: buttonData.enumReport,
                                    id: buttonData.id,
                                    label: buttonData.label);
                              }
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonTopMenu(
                      tile: ButtonTopMenuModel(
                    title: "Colunas",
                    icon: Icons.view_column,
                    onTap: () {
                      controller.stateManager!.showSetColumnsPopup(context);
                    },
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  ButtonTopMenu(
                      tile: ButtonTopMenuModel(
                    title: "Filtros",
                    icon: Icons.filter_list_alt,
                    onTap: () {
                      controller.stateManager!.showFilterPopup(context);
                    },
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: controller.isGraphActive,
                      builder: (context, isPressed, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: PalleteColor.blue),
                                color: isPressed
                                    ? Colors.grey.shade400
                                    : Colors.white,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  controller.isGraphActive.value =
                                      !controller.isGraphActive.value;
                                },
                                icon: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pie_chart,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  SizedBox(
                    width: 5,
                  ),
                  ExportButton(
                    exportCsv: () {
                      var exported = const Utf8Encoder().convert(
                          PlutoGridExport.exportCSV(controller.stateManager!));
                      FileSaveHelper.saveAndLaunchFile(
                          exported, "${DateTime.now()}.csv");
                    },
                    exportPdf: () {
                      ExportPlutoGrid.asPdf(controller.stateManager!);
                    },
                    exportExcel: () {
                      ExportPlutoGrid.asExcel(controller.stateManager!);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: hg * 0.65,
          width: wd * 0.97,
          child: PlutoGridExamplePage(
            collumn: controller.getCollumnsReport(setReport: setReport),
            futureRow: controller.getRows(id: Config.id),
            title: "Relatório",
            controller: controller,
            stateManager: controller.stateManager,
          ),
        ),
      ],
    );
  }
}
