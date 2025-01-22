import 'dart:math';
import 'package:accessibility_audit/home/home_page/graph_home/model/model_graph.dart';
import 'package:accessibility_audit/report/model/domain_model.dart';
import 'package:accessibility_audit/report/repository/domain_repository.dart';

class HomeChartController {

  DomainRepository _repo = DomainRepository();

  Map<String, double> dataMap = {
    "": 5
  };

  Future<Map<String, double>> call() async {

    List<DomainModel> list = await _repo.get();

    dataMap.clear();

    // Processar cada elemento da lista
    for (var element in list) {
   

      // Formatar o nome (se necessário)
      var nomeFormatado = element.municipio;

      // Adicionar os valores ao mapa
      dataMap[nomeFormatado] = element.notaDominio;
    }


    // Remover entradas desnecessárias
    dataMap.remove("");
    dataMap.remove("no name");

    return dataMap;
  }

  String formatarNome(String nome, double num) {
    if (num > 15) {
      if (nome.length > 7) {
        return nome.replaceAllMapped(
          RegExp('.{1,7}'),
          (match) => '${match.group(0)}\n',
        ).trim();
      }
    } else if (num > 10) {
      if (nome.length > 10) {
        return nome.replaceAllMapped(
          RegExp('.{1,10}'),
          (match) => '${match.group(0)}\n',
        ).trim();
      }
    }

    return nome;
  }
}
