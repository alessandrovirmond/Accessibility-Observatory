
import 'package:accessibility_audit/library/pluto_grid/src/helper/filter_helper.dart';
import 'package:accessibility_audit/library/pluto_grid/src/model/pluto_column.dart';

class NotContains implements PlutoFilterType {
  @override
  PlutoCompareFunction get compare => compareNotContains;

  @override
  String get title => "Não Contém:";

  bool compareNotContains({
    required String? base,
    required String? search,
    required PlutoColumn column,
  }) {
    return _compareWithRegExp(
      r"^(?!.*" + RegExp.escape(search!) + r").*$", // Corrige o regex
      base!,
    );
  }

  static bool _compareWithRegExp(
    String pattern,
    String value, {
    bool caseSensitive = false,
  }) {
    return RegExp(
      pattern,
      caseSensitive: caseSensitive,
    ).hasMatch(value);
  }

  @override
  String? get presetValue => null;
}
