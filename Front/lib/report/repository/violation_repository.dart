import 'dart:convert';
import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/report/model/violation_model.dart';
import 'package:accessibility_audit/services/http_dio/http_request.dart';
import 'package:flutter/services.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';


class  ViolationRepository {
  final HttpRequest _http =
      HttpRequest();
 

  Future<List<ViolationModel>> get({Map<String, dynamic>? qsparam, required int id}) async {
    Map<String, dynamic> res = await _http.doGet(qsparam: qsparam, path: "subdomains/$id/violations"); 

    return res["data"]
        .map<ViolationModel>(
            (r) => ViolationModel.fromJson(r))
        .toList();
  }
}
