import 'dart:convert';

import 'package:accessibility_audit/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import './http_request_error.dart';

class HttpRequestMassiveData {

  int total = 0;
  final String path;
  Map<String, dynamic>? qsparam;
  final bool auth;

  BuildContext? context;

  final BehaviorSubject<int> percentsStream = BehaviorSubject();

  get percentsValue => percentsStream.stream;

  HttpRequestMassiveData(this.path, {this.context, this.qsparam, this.auth = true});

  Dio dio = Dio();

  String back = Config.backend;

Future<Map<String, dynamic>> doGet({Map<String, dynamic>? qsparam}) async {
  late Response response;
  percentsStream.sink.add(0);

  int offset = 0;
  List<Map<String, dynamic>> allData = [];

  try {
    while (true) {
      if (auth) {
        Map<String, String> headers = {
          
          "Content-Type": "application/json"
        };

        qsparam ??= {};
        qsparam.addAll({
          "offset": offset,

        });

        response = await dio.get(
          "$back/$path",
          queryParameters: qsparam,
          options: Options(headers: headers),
          onReceiveProgress: (atual, totalData) {
            double percents = (atual * 100 / totalData);
            percentsStream.sink.add(percents.toInt());
          },
        );

        // ignore: avoid_print
        print("GET AUTH:$back/$path OFFSET: $offset");
      } else {
        Map<String, String> headers = {"Content-Type": "application/json"};
        qsparam ??= {};
        qsparam.addAll({
          "offset": offset,
/*           "limit": 2000, */
        });

        response = await dio.get(
          "$back/$path",
          queryParameters: qsparam,
          options: Options(headers: headers),
        );

        // ignore: avoid_print
        print("GET NO AUTH:$back/$path OFFSET: $offset");
      }

      if (response.statusCode == 200) {
        List<dynamic> result = response.data["data"]["counter"];
        allData.addAll(List<Map<String, dynamic>>.from(result));
        break;
      } else if (response.statusCode == 206) {
        List<dynamic> result = response.data["data"]["counter"];
        allData.addAll(List<Map<String, dynamic>>.from(result));
        offset += 2000;
      } else {
        throw HttpRequestError(
          
            message: response.data["message"] ?? "Unknown error",
            path: '/$path',
            statusCode: response.statusCode ?? 0,
            verbose: "GET");
      }
    }
  } on DioException catch (e) {
    throw HttpRequestError(
     
        message: e.response?.data["message"] ?? "Unknown error",
        path: '/$path',
        statusCode: e.response?.statusCode ?? 0,
        verbose: "GET");
  }
  return {"data": allData};
}

  Future<Map<String, dynamic>> doGetId(
      {Map<String, dynamic>? qsparam, required int id}) async {
    late Response response;
    percentsStream.sink.add(0);

        qsparam ??= {};

        qsparam.addAll({
        });

    try {
      if (auth) {
        Map<String, String> headers = {
          
          "Content-Type": "application/json"
        };

        response = await dio.get("$back/$path/$id",
            queryParameters: qsparam, options: Options(headers: headers),
            onReceiveProgress: (atual, totalData) {
          double percents = (atual * 100 / totalData);
          percentsStream.sink.add(percents.toInt());
        });

        // ignore: avoid_print
        print("GET AUTH:$back/$path/$id");
      } else {
        Map<String, String> headers = {"Content-Type": "application/json"};
        response = await dio.get("$back/$path/$id",
            queryParameters: qsparam, options: Options(headers: headers));

        // ignore: avoid_print
        print("GET NO AUTH:$back/$path/$id");
      }
    } on DioException catch (e) {
      HttpRequestError(
          message: e.response!.data["message"],
          path: '/$path/$id',
          statusCode: e.response!.statusCode ?? 0,
          verbose: "GET");

      return response.data;
    }
    return response.data;
  }

Future<Map<String, dynamic>> doGetInBatches({
  Map<String, dynamic>? qsparam,
  required String path,
  int size = 5000,
}) async {
  late Response response;
  percentsStream.sink.add(0);

  int offset = 0;
  int limit = size;
  List<Map<String, dynamic>> allData = [];
  int accumulatedData = 0;
  int total = 0; // Total de itens a serem processados
  bool useSingleRequest = false;

  // Requisição inicial para obter o total, isolada em um try-catch para lidar com 404
  try {
    Map<String, String> headers = auth
        ? {
            
            "Content-Type": "application/json"
          }
        : {"Content-Type": "application/json"};

    response = await dio.get(
      "$back/$path/length",
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      total = response.data["data"]["total"];
    } else {
      useSingleRequest = true; // Caso o status não seja 200, define para fazer uma única requisição
    }
  } catch (e) {
    // Se houver erro, como um 404, faz uma única requisição com onReceiveProgress
    useSingleRequest = true;
  }

  try {
    // Caso total seja menor ou igual ao limite, ou se o `useSingleRequest` for `true`, faz uma única requisição
    if (useSingleRequest || total <= limit) {
      print("Realizando uma única requisição devido a erro ou total menor que o limite");
      Map<String, String> headers = auth
          ? {
              
              "Content-Type": "application/json"
            }
          : {"Content-Type": "application/json"};

      qsparam ??= {};
      qsparam.addAll({
        "offset": offset,
        "limit": total > 0 ? total : limit, // limite é o total ou o limite padrão
      });

      response = await dio.get(
        "$back/$path",
        queryParameters: qsparam,
        options: Options(headers: headers),
        onReceiveProgress: (received, totalData) {
          double percents = (received * 100 / totalData);
          percentsStream.sink.add(percents.toInt());
        },
      );

      if (response.statusCode == 200) {
        allData.addAll(List<Map<String, dynamic>>.from(response.data["data"]["counter"]));
      }
    } else {
      // Caso contrário, faz requisições em lotes
      while (true) {
        Map<String, String> headers = auth
            ? {
                
                "Content-Type": "application/json"
              }
            : {"Content-Type": "application/json"};

        qsparam ??= {};
        qsparam.addAll({
          "offset": offset,
          "limit": limit,
        });

        response = await dio.get(
          "$back/$path",
          queryParameters: qsparam,
          options: Options(headers: headers),
          onReceiveProgress: (received, _) {
            double percents = (accumulatedData * 100 / total);
            percentsStream.sink.add(percents.toInt());
          },
        );

        print("GET OFFSET: $offset LIMIT: $limit");

        if (response.statusCode == 200 || response.statusCode == 206) {
          List<dynamic> result = response.data["data"]["counter"];
          accumulatedData += result.length;
          allData.addAll(List<Map<String, dynamic>>.from(result));

          // Atualiza o progresso após adicionar os dados recebidos
          double percents = (accumulatedData * 100 / total);
          percentsStream.sink.add(percents.toInt());

          if (result.length < limit) {
            break;
          }

          offset += limit;
        } else {
          throw HttpRequestError(
            
            message: response.data["message"] ?? "Unknown error",
            path: '/$path',
            statusCode: response.statusCode ?? 0,
            verbose: "GET",
          );
        }
      }
    }
  } on DioException catch (e) {
    throw HttpRequestError(
     
      message: e.response?.data["message"] ?? "Unknown error",
      path: '/$path',
      statusCode: e.response?.statusCode ?? 0,
      verbose: "GET",
    );
  }

  return {"data": allData};
}



}
