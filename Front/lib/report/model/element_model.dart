import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_cell.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_row.dart';

class ElementModel {

  final String elemento;
  final String seletores;
  final String contexto;


  ElementModel({

    required this.elemento,
    required this.seletores,
    required this.contexto,

  });

  // Método para facilitar a criação de uma instância a partir do JSON, se necessário
  factory ElementModel.fromJson(Map<String, dynamic> json) {
    return ElementModel(
   
      elemento: json['elemento_html'] ?? '',
      seletores: json['selectores'] ?? '',
      contexto: json['texto_contexto'] ?? '',
     
    );
  }

  PlutoRow toRow() {
    return PlutoRow(
      cells: {
        'Elemento HTML': PlutoCell(value: elemento),
        'Seletores': PlutoCell(value: seletores),
        'Contexto': PlutoCell(value: contexto),

      },
    );
  }
}