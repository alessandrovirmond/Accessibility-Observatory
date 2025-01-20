// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFieldRegEx {
  //////REGEX
  static RegExp hexadecimal = RegExp(r'[a-fA-F0–9][a-fA-F0–9]{24}');

  static RegExp dateBrazil = RegExp(
      r'^([1-9]|([012][0-9])|(3[01]))\/([0]{0,1}[1-9]|1[012])\/\d\d\d\d\s([0-1]?[0-9]|2?[0-3]):([0-5]\d)$');

  ///////Filtering
  static List<TextInputFormatter> filterEpc = [
    FilteringTextInputFormatter.allow(RegExp(
      '[0-9a-fA-F]',
    )),
  ];

    static List<TextInputFormatter> maskDate = [
    MaskTextInputFormatter(mask: '##/##/####'),
    FilteringTextInputFormatter.digitsOnly
  ];

    static List<TextInputFormatter> maskCurrency = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\d{0,2}')),
/*     MaskTextInputFormatter(mask: '##,##'), */
  ];
  static String prepareNumberPeso(int total) {
    NumberFormat numberFormat = NumberFormat('###,###.##', 'pt_BR');
    return numberFormat.format(total ~/ 1000);
  }

  static String prepareNumberPesoKG(int total) {
    NumberFormat numberFormat = NumberFormat('###,###.##', 'pt_BR');
    return numberFormat.format(total);
  }

  static String prepareNumberReais(int total) {
    NumberFormat numberFormat = NumberFormat('###,###.##', 'pt_BR');
    return numberFormat.format(total);
  }
   static String convertInventorySituation(String e) {
    switch (e) {
      case "FOUND":
        return "Encontrado no Inventário";
      case "NOT_FOUND":
        return "Não encontrado no Inventário";
      case "NOT_AUTHORIZED":
        return "Movimentação não autorizada";
      case "UNKNOWN":
        return "Desconhecida nessa Data";
      case "OTHER_LOCATION":
        return "Foi Encontrada em Outra Localização";
      case "MANUAL_MOVEMENT":
        return "Foi Movimentada";
      case "PORTAL_OUT":
        return "Saída";
      case "PORTAL_IN":
        return "Entrada";
      case "RETURN":
        return "Retornado";
      case "BORROW":
        return "Emprestado";
      case "COUNT":
        return "Foi Encontrada na Contagem";
      default:
        return e;
    }
  }

  static int stringToInt(String s) {
    if (s.isEmpty) {
      return 0;
    } else {
      try {
        return int.parse(s);
      } catch (e) {
        return 0;
      }
    }
  }
}
