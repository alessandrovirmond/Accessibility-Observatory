// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

class EasyInterfaces {

  static DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm');

  static String dateTimeBrazillian(int time) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time, isUtc: false);
    String dateDay =
        date.day.toString().length == 1 ? "0${date.day}" : date.day.toString();
    String dateMonth = date.month.toString().length == 1
        ? "0${date.month}"
        : date.month.toString();
    String dateMinute = date.minute.toString().length == 1
        ? "0${date.minute}"
        : date.minute.toString();
    return "$dateDay/$dateMonth/${date.year}   ${date.hour}:$dateMinute";
  }

  static int dateTimeCalc(String date) {
    return 0;
  }

  static int convertInMillesecondsWithHour(String date) {
    DateTime parse = formatter.parse(date);
    return parse.millisecondsSinceEpoch;
  }

  static hourBrazillian(int time) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
    String dateMinute = date.minute.toString().length == 1
        ? "0${date.minute}"
        : date.minute.toString();

    return "${date.hour}:$dateMinute";
  }
}
