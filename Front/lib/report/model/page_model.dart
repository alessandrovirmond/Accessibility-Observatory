import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_cell.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';

class PageModel {
  final int id;
  final String? nomePagina;
  final double? nota;
  final int? violacoes;
  final int? elementosAfetados;
  final int? elementosTestados;

  PageModel({
    required this.id,
    this.nomePagina,
    this.nota,
    this.violacoes,
    this.elementosAfetados,
    this.elementosTestados,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['subdominio_id'],
      nomePagina: json['subdominio_url'],
      nota: json['subdominio_nota'] is double
          ? json['subdominio_nota']
          : double.tryParse(json['subdominio_nota'].toString()) ?? 0.0,
      violacoes: json['violacoes'],
      elementosAfetados: json['elementos_afetados'],
      elementosTestados: json['elementosTestados'],

    );
  }

  PlutoRow toRow() {
    return PlutoRow(
      cells: {
   
        'E': PlutoCell(value: "$id*&*$nomePagina"),
        'Página': PlutoCell(value: nomePagina),
        'Nota': PlutoCell(value: nota?.toStringAsFixed(2)),
        'Violações': PlutoCell(value: violacoes),
        'Elementos Afetados': PlutoCell(value: elementosAfetados),
        'Elementos Testados': PlutoCell(value: elementosAfetados),
      },
    );
  }
}
