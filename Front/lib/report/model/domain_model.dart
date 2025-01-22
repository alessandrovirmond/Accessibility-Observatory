import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_cell.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';

class DomainModel {
  final int id;
  final String dominio;
  final String municipio;
  final String estado;
  final int totalViolacoes;
  final int totalPaginas;
  final int mediaViolacoesPorPagina;
  final int mediaElementosAfetadosPorPagina;
  final double notaDominio;

  DomainModel({
    required this.id,
    required this.dominio,
    required this.municipio,
    required this.estado,
    required this.totalViolacoes,
    required this.totalPaginas,
    required this.mediaViolacoesPorPagina,
    required this.mediaElementosAfetadosPorPagina,
    required this.notaDominio,
  });
factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      id: json['dominio_id'] is int
          ? json['dominio_id']
          : int.tryParse(json['dominio_id'].toString()) ?? 0,
      dominio: json['dominio'] ?? '',
      estado: json['estado'] ?? '',
      municipio: json['municipio'] ?? '',
      totalViolacoes: json['total_violacoes'] is int
          ? json['total_violacoes']
          : int.tryParse(json['total_violacoes'].toString()) ?? 0,
      totalPaginas: json['total_paginas'] is int
          ? json['total_paginas']
          : int.tryParse(json['total_paginas'].toString()) ?? 0,
      mediaViolacoesPorPagina: _convertDoubleToInt(
          json['media_violacoes_por_pagina']),
      mediaElementosAfetadosPorPagina: _convertDoubleToInt(
          json['media_elementos_afetados_por_pagina']),
      notaDominio: json['nota_dominio'] is double
          ? json['nota_dominio']
          : double.tryParse(json['nota_dominio'].toString()) ?? 0.0,
    );
  }

  // Método para transformar o modelo em uma linha para o PlutoGrid
  PlutoRow toRow() {
    return PlutoRow(
      cells: {
        'E': PlutoCell(value: "$id*&*$dominio"),
        'Domínio': PlutoCell(value: dominio),
        'Município': PlutoCell(value: municipio),
        'Estado': PlutoCell(value: estado),
        'Total de Violações': PlutoCell(value: totalViolacoes),
        'Média de Violações por Página': PlutoCell(value: mediaViolacoesPorPagina),
        'Média de Elementos Afetados por Página':
            PlutoCell(value: mediaElementosAfetadosPorPagina),
        'Nota': PlutoCell(value: notaDominio.toStringAsFixed(2)),
        'Total de Páginas': PlutoCell(value: totalPaginas),
      },
    );
  }

   // Função auxiliar para converter double (como string ou número) em int
  static int _convertDoubleToInt(dynamic value) {
    if (value is double) {
      return value.toInt(); // Trunca o valor
    } else if (value is String) {
      final double? parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed.toInt(); // Trunca o valor
      }
    }
    return 0; // Valor padrão se for inválido
  }
}