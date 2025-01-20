import 'package:accessibility_audit/uitls/global_pages_utils/loading/global_page_loading.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controller/dashboard_controller.dart';
import '../controller/generator_file/pdf_generator.dart';
import '../models/enum_graph_style.dart';
import '../models/model_selector_graph.dart';
import '../repository/consumer.dart';
import 'components/float_grid_selecter.dart';
import 'graphs/model_graph_chart_bar.dart';
import 'graphs/model_graph_pie.dart';
import 'graphs/model_graph_pyramid.dart';

class DashboardMain extends StatefulWidget {
  static bool details = false;
  const DashboardMain({super.key});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  late final DashboardController _controller;
  final DashboardRepository _repository = DashboardRepository();
  late final Function update;
  late GlobalKey<SfCircularChartState> _circularChartKey;
  final RenderPdf pdf = RenderPdf();

  @override
  void initState() {
    _circularChartKey = GlobalKey();

    _controller = DashboardController(update: () => setState(() {}), [
      ModelSelectorGraph(
          "Peso x Fornecedor", _repository.getGraphFornPeso, true),
      ModelSelectorGraph(
          "Qtd x Localização", _repository.getGraphQuantidadeLocation, false),
      ModelSelectorGraph(
          "Peso x Localização", _repository.getGraphPesoLocation, true),
      ModelSelectorGraph("Qtd x Produto", _repository.getGraphQtdProd, false),
      ModelSelectorGraph("Peso x Produto", _repository.getGraphPesoProd, true),
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        toolbarHeight: 36,
        actions: [
          const SizedBox(width: 7),
          IconButton(
              onPressed: () =>
                  pdf.renderPdf(_circularChartKey, _controller.modelsTitle),
              icon: const Icon(
                FontAwesomeIcons.filePdf,
                color: PalleteColor.red,
              )),
        ],
        leadingWidth: 300,
        leading: Row(children: [
          const SizedBox(width: 7),
          IconButton(
            icon: const Icon(
              Icons.pie_chart,
              color: PalleteColor.red,
            ),
            onPressed: () =>
                setState(() => ModelSelectorGraph.graph = GraphStyle.pie),
          ),
          const SizedBox(width: 7),
          IconButton(
            icon: const Icon(
              FeatherIcons.triangle,
              color: PalleteColor.red,
            ),
            onPressed: () =>
                setState(() => ModelSelectorGraph.graph = GraphStyle.pyramid),
          ),
          const SizedBox(width: 7),
          IconButton(
            icon: const Icon(
              Icons.bar_chart,
              color: PalleteColor.red,
            ),
            onPressed: () =>
                setState(() => ModelSelectorGraph.graph = GraphStyle.bar),
          )
        ]),
      ),
      body: Padding(
        padding: MyStyles.margin,
        child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 80,
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FloatSelecterGrid(controller: _controller)),
                ),
                Expanded(
                    child: FutureBuilder(
                        future: _controller.modelsList,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const GlobalPageLoading();
                          }
                          double total = 0;
                          for (var element in snap.data!) {
                            total += element.value;
                          }

                          switch (ModelSelectorGraph.graph) {
                            case GraphStyle.pie:
                              return PieModelChart(
                                  peso: _controller.peso,
                                  title: _controller.modelsTitle,
                                  model: snap.data!,
                                  keyChart: _circularChartKey,
                                  total: total);

                            case GraphStyle.pyramid:
                              return PyramidChartModel(
                                  peso: _controller.peso,
                                  title: _controller.modelsTitle,
                                  model: snap.data!,
                                  keyChart: _circularChartKey,
                                  total: total);

                            case GraphStyle.bar:
                              return ChartBarModel(
                                  peso: _controller.peso,
                                  title: _controller.modelsTitle,
                                  model: snap.data!,
                                  keyChart: _circularChartKey,
                                  total: total);

                            default:
                              return const SizedBox.shrink();
                          }
                        })),
              ],
            )),
      ),
    );
  }
}
