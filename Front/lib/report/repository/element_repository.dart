import 'dart:convert';
import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/report/model/element_model.dart';
import 'package:accessibility_audit/services/http_dio/http_request.dart';
import 'package:flutter/services.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';


class  ElementRepository {
  final HttpRequest _http =
      HttpRequest();
 

  Future<List<ElementModel>> get({Map<String, dynamic>? qsparam, required int id}) async {
    Map<String, dynamic> res = await _http.doGet(qsparam: qsparam, path: "violations/$id/elements"); 

    return res["data"]
        .map<ElementModel>(
            (r) => ElementModel.fromJson(r))
        .toList();
  }
}
