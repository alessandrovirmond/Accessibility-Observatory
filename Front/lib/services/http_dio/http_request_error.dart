import 'package:accessibility_audit/home/home.dart';
import 'package:accessibility_audit/uitls/message/maker_message.dart';
import 'package:accessibility_audit/uitls/message/time_pop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HttpRequestError {
  final int statusCode;
  final String message;
  final String path;
  final String verbose;
  final bool renderMessage;
  HttpRequestError( 
      {required this.statusCode,
      required this.message,
      required this.path,
      required this.verbose,
      this.renderMessage = true
      }) {
    if (kDebugMode) {
      print("*********************ERROR*************************");
      print("$verbose:$path");
      print("status code:${statusCode.toString()}");
      print("message:$message");
    }
    late final String messageError;

   /*  switch (verbose) {

      case "GET":
        messageError = "Não Foi possível Carregar";
        break;
      case "POST":
        messageError = "Não foi possível Salvar";
        break;
      case "PUT":
        messageError = "Não foi Possível Salvar";
        break;
      case "DELETE":
        messageError = "Não foi Possível Deletar";
        break;

      default:
        messageError = "Não foi possível identificar o Erro";
    } */
    if(renderMessage){
      print( "------------ DEU ERRO");
    MakerMessage.error( 
      "Server Error $statusCode",
      Text("$message", textAlign: TextAlign.center),
      context: Home.homeContext
    );
  }
  }
}
