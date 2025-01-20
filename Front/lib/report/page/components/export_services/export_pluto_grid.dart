import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:accessibility_audit/library/pluto_grid/src/manager/pluto_grid_state_manager.dart';
import 'package:accessibility_audit/library/pluto_grid_export/pluto_grid_plus_export.dart';
import 'package:accessibility_audit/library/pluto_grid_export/src/pluto_grid_plus_export.dart';
import 'package:accessibility_audit/library/pluto_grid/pluto_grid_plus.dart';
import 'package:accessibility_audit/library/pluto_grid_export/pluto_grid_plus_export.dart';
import 'package:accessibility_audit/library/pluto_grid_export/src/pluto_grid_plus_export.dart';
import '../../../../services/file_save/save_file.dart';

class ExportPlutoGrid {
  
  static void asCsv(PlutoGridStateManager stateManager) {
    var exported = const Utf8Encoder()
        .convert( PlutoGridExport.exportCSV(stateManager));
    FileSaveHelper.saveAndLaunchFile(exported, "RFIDFácil ${DateTime.now().toIso8601String()}.csv");
  }


  static void asPdf(PlutoGridStateManager stateManager) async {
    final themeData = ThemeData.base();

    var plutoGridPdfExport = PlutoGridDefaultPdfExport(
      title: "RFID Fácil",
      creator: "RFIDFácil",
      format: PdfPageFormat.a3.landscape,
      themeData: themeData,
    );

    FileSaveHelper.saveAndLaunchFile(
        await plutoGridPdfExport.export(stateManager),
        "RFIDFácil ${DateTime.now().toIso8601String()}.pdf");
  }

static void asExcel(PlutoGridStateManager stateManager) {
  // Exporta o conteúdo da tabela para CSV e converte para lista de listas.
  List<int> exported = const Utf8Encoder()
      .convert(PlutoGridExport.exportCSV(stateManager));
  String input = utf8.decode(exported);
  CsvToListConverter csv = const CsvToListConverter();
  List<List<dynamic>> rows = csv.convert(input);

  //Deletando cabecalho
  rows.removeAt(0);

 // Adiciona o cabeçalho das colunas.
  List<String> headers = stateManager.columns.map((column) => column.title).toList();

  // Verifica se a primeira coluna tem nome vazio.
  if (headers.isNotEmpty && headers[0].isEmpty) {
    // Remove a primeira coluna dos cabeçalhos. Coluna de historico
    headers.removeAt(0);

    // Remove a primeira coluna de todas as linhas de dados.
    rows = rows.map((row) {
      // Verifica se a linha tem elementos suficientes e remove o primeiro elemento.
      return row.isNotEmpty ? row.sublist(1) : row;
    }).toList();
  }

  int deleteColumnIndex = stateManager.columns.indexWhere((column) => column.field == 'Deletar');

  bool delete = false;

  List<List<dynamic>> rowsToExport;

  // Verifica se a coluna "Deletar" existe.
  if (deleteColumnIndex != -1) {
    // Filtra as linhas para incluir apenas aquelas em que a coluna "Deletar" está marcada como true.
    List<List<dynamic>> filteredRows = rows.where((row) {
      return row[deleteColumnIndex - 1].toString().toLowerCase() == 'true';
    }).toList();

    delete = filteredRows.isNotEmpty;

    // Se houver linhas com "Deletar" marcada como true, exporta essas linhas. Caso contrário, exporta todas.
    rowsToExport = delete ? filteredRows : rows;
  } else {
    // Se a coluna "Deletar" não existir, exporta todas as linhas normalmente.
    rowsToExport = rows;
  }

  // Exporta as linhas filtradas ou todas as linhas, garantindo que o cabeçalho seja incluído apenas uma vez.
  _exportRowsToExcel(rowsToExport, headers, delete);
}

// Função para exportar as linhas para o Excel com o cabeçalho.
static void _exportRowsToExcel(List<List<dynamic>> rows, List<dynamic> header, bool delete) {
  // Cria um novo arquivo Excel.
  final excel = Excel.createExcel();
  excel.rename(excel.getDefaultSheet()!, "RFID");
  final sheet = excel["RFID"];


  // Adiciona o cabeçalho ao Excel (apenas uma vez).
  sheet.appendRow(header.map((e) => TextCellValue(e.toString())).toList());

  // Adiciona as linhas ao Excel.
  for (var element in rows) {
    List<CellValue?> row = element.map((e) => TextCellValue(e.toString())).toList();
    sheet.appendRow(row);
  }

  // Aplica estilo ao cabeçalho (primeira linha).
  sheet.row(0).forEach((Data? element) {
    element!.cellStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString("#263163"),
      bold: true,
      fontColorHex: ExcelColor.fromHexString("#FFFFFF"),
    );
  });

  // Salva e abre o arquivo Excel.
  FileSaveHelper.saveAndLaunchFile(excel.encode()!, delete ? "RFIDFácil EXCLUSÃO ${DateTime.now().toIso8601String()}.xlsx" :
  "RFIDFácil ${DateTime.now().toIso8601String()}.xlsx");
}


}
