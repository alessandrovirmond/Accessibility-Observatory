import 'package:accessibility_audit/report/controller/enum/enum_report.dart';

class ButtonData {
  final String label;
  final int id;
  final EnumReport enumReport;

  ButtonData({required this.label, required this.id, required this.enumReport});
}