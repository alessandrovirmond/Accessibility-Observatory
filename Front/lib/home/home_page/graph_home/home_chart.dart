import 'package:accessibility_audit/home/home_page/graph_home/controller/chart_data.dart';
import 'package:accessibility_audit/home/home_page/graph_home/controller/home_chart_controller.dart';
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

  late Future<Map<String, double>> dataMap;

  @override
  void initState() {
    dataMap = controller.call();
    super.initState();
  }

  void update() {
    setState(() {
      dataMap = controller.call();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                labelIntersectAction: AxisLabelIntersectAction.trim,
                                majorGridLines: const MajorGridLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                labelStyle: const TextStyle(fontSize: 10),
                                majorTickLines: const MajorTickLines(size: 6),
                                majorGridLines: const MajorGridLines(width: 0),
                                numberFormat: NumberFormat('#,##0.00'), // Permite exibição de double
                                name: "Nota",
                              ),
                              axes: <ChartAxis>[
                                NumericAxis(
                                  opposedPosition: true,
                                  labelStyle: const TextStyle(fontSize: 10),
                                  majorTickLines: const MajorTickLines(size: 6),
                                  axisLine: const AxisLine(width: 0),
                                  majorGridLines: const MajorGridLines(width: 0),
                                  name: "Páginas",
                                  numberFormat: NumberFormat('#,##0'), // Este eixo pode ser mantido como inteiro
                                ),
                              ],
                              series: [
                                ColumnSeries<ChartData, String>(
                                  dataSource: createChartData(data),
                                  xValueMapper: (ChartData data, _) => data.name,
                                  yValueMapper: (ChartData data, _) => data.value,
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
