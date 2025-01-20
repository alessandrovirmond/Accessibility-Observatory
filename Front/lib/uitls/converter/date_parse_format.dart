// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DateParseFormat {

  static String formatMilliseconds(int milliseconds) {
    if(milliseconds == 0){
      return "";
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return dateFormat.format(dateTime);
  }

    static String formatMillisecondsHour(int milliseconds) {
    if(milliseconds == 0){
      return "";
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    DateFormat dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

    return dateFormat.format(dateTime);
  }

static int parseMilliseconds(String dateString) {
  try {
    
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    DateTime dateTime = dateFormat.parse(dateString);
    return dateTime.millisecondsSinceEpoch;
  } catch (e) {
    return 0;
  }
}

  static int parseDateToMilliseconds(String date) {
    if (date.isEmpty) {
      return 0;
    }

    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime dateTime = dateFormat.parse(date);

  return dateTime.millisecondsSinceEpoch;
}

 static MaskTextInputFormatter dateMask =
      MaskTextInputFormatter(mask: '##/##/####');
}
