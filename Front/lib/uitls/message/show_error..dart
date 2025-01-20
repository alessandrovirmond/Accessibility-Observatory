import 'package:accessibility_audit/uitls/message/time_pop.dart';
import 'package:flutter/material.dart';

class ErrorMessage{
  static void showError(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimePop(
          title: title,
          message: Text(message, style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}