



import 'dart:developer';

class DoPrint{

  static void httpRequest(String message){
      log("HTTP:$message", name: "HTTP RESPONSE", time: DateTime.now(), level: 100);
  }

  static void developerTest( String message ,{String? filter}){
      log("${filter ?? "DEV"}:$message", name: filter ?? "DEV", time: DateTime.now(), level: 2000);
  }


   static void errorTest(String message ,{String? page}){
      log("${page ?? "DEV"}:$message", name: page ?? "DEV", time: DateTime.now(), level: 2000);
  }





}