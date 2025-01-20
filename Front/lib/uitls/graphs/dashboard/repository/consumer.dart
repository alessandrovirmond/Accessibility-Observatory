


import 'package:accessibility_audit/services/http_dio/http_request.dart';
import '../models/models_graph.dart';

class DashboardRepository{

 final HttpRequest _http = HttpRequest();

  Future<List<ModelGraph>> getGraphFornPeso({Map<String,dynamic>? qsparam}) async{
    
   Map<String,dynamic> response = await _http.doGet(path: "v1/dashboard/supplier-per-heigth");


   List<ModelGraph> res = response["data"].map<ModelGraph>((e) => ModelGraph(e["Fornecedor"] ?? "total", e["Peso"])).toList();
   
   ///   @Armeng
   res.removeAt(0);



    return res;
}


Future<List<ModelGraph>> getGraphPeso ({Map<String,dynamic>? qsparam})async{

Map<String,dynamic> response = await _http.doGet(path: "v1/dashboard/");

return response["data"].map<ModelGraph>((e) => ModelGraph(e["Nome"], e["Peso"]));

}


////@ARMENG
Future<List<ModelGraph>> getGraphQuantidadeLocation ({Map<String,dynamic>? qsparam})async{

Map<String,dynamic> response = await _http.doGet(path: "v1/dashboard?param=Location");
/// @ARMENG TOTAL APARECE NOO MEIO DO JSON
return response["data"].map<ModelGraph>((e) => ModelGraph(e["Nome"] ?? "", e["Quantidade"] ?? 0)).toList();

}

////@ARMENG
Future<List<ModelGraph>> getGraphPesoLocation ({Map<String,dynamic>? qsparam})async{

Map<String,dynamic> response = await _http.doGet(path: "v1/dashboard?param=Location");
/// @ARMENG TOTAL APARECE NOO MEIO DO JSON
return response["data"].map<ModelGraph>((e) => ModelGraph(e["Nome"] ?? "no name", e["Peso"] ?? 0)).toList();

}

////@ARMENG
Future<List<ModelGraph>> getGraphQtdProd ({Map<String,dynamic>? qsparam})async{

Map<String,dynamic> response = await _http.doGet(path: "v1/dashboard?param=Product");
/// @ARMENG TOTAL APARECE NOO MEIO DO JSON
return response["data"].map<ModelGraph>((e) => ModelGraph(e["Nome"] ?? "no name", e["Quantidade"] ?? 0)).toList();

}

////@ARMENG
Future<List<ModelGraph>> getGraphPesoProd ({Map<String,dynamic>? qsparam})async{

Map<String,dynamic> response = await _http.doGet(path: "v1/dashboard?param=Product");
/// @ARMENG TOTAL APARECE NOO MEIO DO JSON
return response["data"].map<ModelGraph>((e) => ModelGraph(e["Nome"] ?? "no name", e["Peso"] ?? 0)).toList();

}








}