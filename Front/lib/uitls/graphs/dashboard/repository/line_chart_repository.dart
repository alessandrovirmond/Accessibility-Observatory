


import 'package:accessibility_audit/services/http_dio/http_request.dart';
import 'package:accessibility_audit/uitls/graphs/dashboard/models/line_chart_model.dart';
import 'package:flutter/material.dart';

class LineChartRepository{


  Future<List<LineChartModel>> getLineChart({required int millisecond})async{

     final HttpRequest _http = HttpRequest(); 

    Map<String,dynamic> res = (await _http.doGet(path: "linearchart", qsparam: {"start" : millisecond ?? 0}))["data"];

    return (res["chart"] as List).map((e)=> LineChartModel.fromJson(e)).toList();

  }

}