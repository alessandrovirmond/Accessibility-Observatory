import 'dart:convert';
import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/report/model/page_model.dart';
import 'package:accessibility_audit/services/http_dio/http_request.dart';
import 'package:flutter/services.dart';
import 'package:accessibility_audit/report/controller/enum/enum_report.dart';


class  PageRepository {
  final HttpRequest _http =
      HttpRequest();
 

  Future<List<PageModel>> get({Map<String, dynamic>? qsparam, required int id}) async {
    Map<String, dynamic> res = await _http.doGet(qsparam: qsparam, path: "domains/$id/subdomains"); 


    return res["data"]
        .map<PageModel>(
            (r) => PageModel.fromJson(r))
        .toList();
  }
}
