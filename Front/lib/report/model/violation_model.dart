import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_cell.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';

class ViolationModel {
  final int id;
  final String violacao;
  final String regraViolada;
  final String comoCorrigir;
  final String maisInformacoes;
  final String nivelImpacto;
  final int elementosAfetados;

  ViolationModel({
    required this.id,
    required this.violacao,
    required this.regraViolada,
    required this.comoCorrigir,
    required this.maisInformacoes,
    required this.nivelImpacto,
    required this.elementosAfetados,
  });

  // Método para facilitar a criação de uma instância a partir do JSON, se necessário
  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: json["id"],
      violacao: json['violacao'] ?? '',
      regraViolada: json['regra_violada'] ?? '',
      comoCorrigir: json['como_corrigir'] ?? '',
      maisInformacoes: json['mais_informacoes'] ?? '',
      nivelImpacto: json['nivel_impacto'] ?? '',
      elementosAfetados: json['elementos_afetados']?? 0
    );
  }

  PlutoRow toRow() {
    return PlutoRow(
      cells: {
        'E': PlutoCell(value: "$id*&*$violacao"),
        'Violação': PlutoCell(value: violacao),
        'Regra Violada': PlutoCell(value: regraViolada),
        'Como Corrigir': PlutoCell(value: comoCorrigir),
        'Mais Informações': PlutoCell(value: maisInformacoes),
        'Nível de Impacto': PlutoCell(value: nivelImpacto),
        'Elementos Afetados': PlutoCell(value: elementosAfetados),
      },
    );
  }
}