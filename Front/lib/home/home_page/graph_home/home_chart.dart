import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/home/home_page/graph_home/controller/chart_data.dart';
import 'package:accessibility_audit/home/home_page/graph_home/controller/home_chart_controller.dart';
import 'package:accessibility_audit/report/repository/state_repository.dart';
import 'package:accessibility_audit/uitls/global_pages_utils/custom_button.dart';
import 'package:accessibility_audit/uitls/global_styles/my_icons.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeChart extends StatefulWidget {
  final bool updateWindows;

  const HomeChart({super.key, required this.updateWindows});

  @override
  State<HomeChart> createState() => _HomeChartState();
}

class _HomeChartState extends State<HomeChart> {
  final HomeChartController controller = HomeChartController();
  bool isLoading = false;
  late Future<Map<String, double>> dataMap;
  final StateRepository stateRepo = StateRepository();
  List<String> estados = ["Todos"];

  // Função para pegar os estados e preencher a lista
  Future<void> _getEstados() async {
    try {
      List<String> estadosObtidos = await stateRepo.getState();
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

  @override
  void initState() {
    dataMap = controller.call();
    _getEstados();
    super.initState();
  }

  void update() {
    setState(() {
      dataMap = controller.call();
    });
  }

  @override
  Widget build(BuildContext context) {

    
      if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 1200;
        return FutureBuilder<Map<String, double>>(
          future: dataMap,
          builder: (context, snapshot) {
            final Map<String, double>? data = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.maxFinite,
                  child: const Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notas de Acessibilidade',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 20 : 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.blue.shade700,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Nota",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 50,),
                                  DropdownButton<String>(
                                    
                                    value: Config.estado.isNotEmpty
                                        ? Config.estado
                                        : "Todos",
                                    items: estados.map((String estado) {
                                      return DropdownMenuItem<String>(
                                        value: estado,
                                        child: Text(estado),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        Config.estado = newValue;
                                        update();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: SfCartesianChart(
                              backgroundColor: Colors.white,
                              plotAreaBorderWidth: 0,
                              primaryXAxis: CategoryAxis(
                                labelStyle: TextStyle(
                                  fontSize: isSmallScreen ? 10 : 12,
                                ),
                                labelIntersectAction:
                                    AxisLabelIntersectAction.trim,
                                majorGridLines: const MajorGridLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                labelStyle: const TextStyle(fontSize: 10),
                                majorTickLines: const MajorTickLines(size: 6),
                                majorGridLines: const MajorGridLines(width: 0),
                                numberFormat: NumberFormat(
                                    '#,##0.00'), // Permite exibição de double
                                name: "Nota",
                              ),
                              
                              series: [
                                ColumnSeries<ChartData, String>(
                                  dataSource: createChartData(data),
                                  xValueMapper: (ChartData data, _) =>
                                      data.name,
                                  yValueMapper: (ChartData data, _) =>
                                      data.value,
                                  name: "Nota",
                                  color: Colors.blue.shade700,
                                ),
                              ],
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                format: 'point.y', // Exibe double no tooltip
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
