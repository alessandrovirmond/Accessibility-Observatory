import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/home/enum/enum_home.dart';
import 'package:accessibility_audit/home/home_page/graph_home/home_chart.dart';
import 'package:accessibility_audit/uitls/global_styles/pallete_color.dart';
import 'package:accessibility_audit/uitls/global_styles/styles.dart';
import 'package:flutter/material.dart';

class GraphHome extends StatefulWidget {
  final Function() onUpdate;
  const GraphHome({super.key, required this.onUpdate});

  @override
  State<GraphHome> createState() => _GraphHomeState();
}

class _GraphHomeState extends State<GraphHome> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: HomeChart(updateWindows: false)),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Monitoramento da acessibilidade",
                            style: MyStyles.subBoldBlack,
                          ),
                          Text(" - 92 sites de prefeitura avaliados"),
                          Text(
                              " - Avaliação de Acessibilidade de acordo com as normas do WCAG 2.0"),
                          Text(
                              " - Nota de acessibilidade considerando grau de impacto das violações no site"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Relatórios detalhados",
                            style: MyStyles.subBoldBlack,
                          ),
                          Text(" - Relatório de páginas do portal municipal"),
                          Text(
                              " - Relatório de violações de acessibilidade de cada página"),
                          Text(
                              " - Relatório de elementos  envolvidos em cada violação"),
                          Text(" - Filtros e gráficos personalizados "),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      
                        child: GestureDetector(
                          onTap: () {
                            Config.enumHome = EnumHome.report;
                            widget.onUpdate();
                          },
                          child: Container(
                              height: 100,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                  child: Text(
                                "Ver Relatório",
                                style: MyStyles.subtitleGridWhite,
                              ))),
                        ),
                      ),
                  
                  ],
                ),
              ),
            ))
      ],
    );
  }
}
