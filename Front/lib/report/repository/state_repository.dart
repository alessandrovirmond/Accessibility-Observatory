import 'dart:convert';
import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/report/model/domain_model.dart';
import 'package:accessibility_audit/services/http_dio/http_request.dart';
import 'package:flutter/services.dart';

class StateRepository {
  final HttpRequest _http = HttpRequest();

  Future<List<String>> get({Map<String, dynamic>? qsparam}) async {
    String estado = Config.estado.replaceAll(' ', "_");
    if (estado == "Todos") {
      estado = "all";
    }
    Map<String, dynamic> res =
        await _http.doGet(qsparam: qsparam, path: "/state");

    return res["data"].map<String>((r) => r.toString()).toList();
  }

  Future<String> getDate({Map<String, dynamic>? qsparam}) async {
    Map<String, dynamic> res =
        await _http.doGet(qsparam: qsparam, path: "/date");

    return res["data"][0]["Update_time"].toString();
  }
}
