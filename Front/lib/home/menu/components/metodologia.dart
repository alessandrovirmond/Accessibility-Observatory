import 'package:flutter/material.dart';

class Metogologia extends StatelessWidget {
  const Metogologia({super.key});

  @override
  Widget build(BuildContext context) {
        final double hg = MediaQuery.of(context).size.height;
    final double wd = MediaQuery.of(context).size.width;

    return Container(
      width: wd/2,
      height: hg * 0.7,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Coleta das páginas dos portais municipais"),
          Text(
              "Utilizando WebScraping, capturou-se o endereço de todas as páginas acessíveis através das páginas principais."),
          Text("Análise de acessibilidade das páginas"),
          Text(
              "Com a ferramenta Axe Dev Tools, as páginas foram analisadas conforme os critérios da WCAG 2.1 AA."),
          Text("Cálculo das notas de acessibilidade das páginas"),
          Text(
              "A nota é calculada com base na severidade das violações e o impacto dos elementos afetados."),
          Text("Observatório de Acessibilidade"),
          Text(
              "Divulgação dos resultados através de gráficos e relatórios detalhados, incluindo notas por portal, páginas e violações."),
        ],
      ),
    );
  }
}
