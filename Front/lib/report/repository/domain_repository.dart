import 'dart:convert';
import 'package:accessibility_audit/report/model/domain_model.dart';
import 'package:accessibility_audit/services/http_dio/http_request.dart';
import 'package:flutter/services.dart';


class  DomainRepository {
  final HttpRequest _http =
      HttpRequest();
 

  Future<List<DomainModel>> get({Map<String, dynamic>? qsparam}) async {
    Map<String, dynamic> res = await _http.doGet(qsparam: qsparam, path: "domains"); 


    return res["data"]
        .map<DomainModel>(
            (r) => DomainModel.fromJson(r))
        .toList();
  }
}
