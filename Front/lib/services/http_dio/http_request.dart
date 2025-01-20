import 'package:accessibility_audit/config.dart';
import 'package:accessibility_audit/home/home.dart';
import 'package:accessibility_audit/uitls/do_print/do_print.dart';
import 'package:accessibility_audit/uitls/message/maker_message.dart';
import 'package:accessibility_audit/uitls/message/time_pop.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'http_request_error.dart';

class HttpRequest {
  Dio dio = Dio();

  BuildContext? context;

  HttpRequest({BuildContext? context}) {
    dio.options = BaseOptions(connectTimeout: const Duration(days: 1));
  }

  String back = Config.backend;

  ///Get
  Future<Map<String, dynamic>> doGet({
    required String path,
    Map<String, dynamic>? qsparam,
    bool auth = true,
  }) async {
    back = Config.backend;

    late Response response;

    try {
      if (auth) {
        Map<String, String> headers = {
          
          "Content-Type": "application/json"
        };

        response = await dio.get("$back/$path",
            queryParameters: qsparam, options: Options(headers: headers));

        Map? partial;
        if (response.statusCode == 206) {
          partial = await doGet(path: response.data["path"].toString());
          (response.data["data"] as List).addAll(partial["data"]);
        }
      } else {
        Map<String, String> headers = {"Content-Type": "application/json"};
        response = await dio.get("$back$path"..replaceAll("//", "/"),
            queryParameters: qsparam, options: Options(headers: headers));
      }
    } on DioException catch (e) {
      DoPrint.errorTest('${Config.backend}$path');
      HttpRequestError(
          
          message: e.response?.data["message"] ?? "",
          path: '${Config.backend}$path',
          statusCode: e.response?.statusCode ?? 0,
          verbose: "GET");

      return response.data;
    }

    return response.data;
  }

  Future<Map> doPost(
      {required String path,
      Map<String, dynamic>? qsparam,
      bool auth = true,
      required Map<String, dynamic> data,
      bool message = true}) async {
    late Response response;

    try {
      if (auth) {
        Map<String, String> headers = {
          
          "Content-Type": "application/json"
        };

        response = await dio.post("$back/$path",
            data: data,
            queryParameters: qsparam,
            options: Options(headers: headers));

        if (message && response.statusCode == 201) {
          MakerMessage.error(
              context: Home.homeContext,
              "Salvo com Sucesso",
              const Text("Criado com sucesso", textAlign: TextAlign.center));
        }
      } else {
        Map<String, String> headers = {"Content-Type": "application/json"};
        response = await dio.post("$back/$path",
            data: data,
            queryParameters: qsparam,
            options: Options(headers: headers));
      }
    } on DioException catch (e) {
      HttpRequestError(
          message: e.response!.data["message"],
          path: '/$path',
          statusCode: e.response!.statusCode ?? 0,
          renderMessage: message,
          verbose: "POST",
         );
      /* return {"mensagem": e.response!.data["message"]}; */
    }
    return response.data;
  }

  Future<Map> doPostAuth({
    required String path,
    Map<String, dynamic>? qsparam,
    bool auth = true,
    required Map<String, dynamic> data,
    bool message = true,
    bool sync = false,
  }) async {
    back = Config.backend;
    DoPrint.httpRequest(
        "$back:::::\nPOST $path, qsParam:${qsparam.toString()}, auth:$auth");
    late Response response;
    try {
      Map<String, dynamic> headers = {"Content-Type": "application/json"};
      response = await dio.post("$back/$path",
          data: data,
          queryParameters: qsparam,
          options: Options(headers: headers));
    } on DioException catch (e) {
      print(e.response?.data["data"]["message"]);
      HttpRequestError(
        
        message: e.response?.data["data"]["message"] ?? "Erro",
        path: '$back/$path',
        statusCode: e.response!.statusCode ?? 0,
        verbose: "POST",
      );

      return e.response!.data;
    }

    return response.data;
  }

  Future<Map> doDelete(
      {required String path,
      Map<String, dynamic>? qsparam,
      bool auth = true,
      Map<String, dynamic>? data,
      bool message = true,
      bool sync = false}) async {
    back = Config.backend;
    late Response response;
    DoPrint.httpRequest(
        "$back:::::\nDELETE $path, qsParam:${qsparam.toString()}, auth:$auth");
    try {
      if (auth) {
        Map<String, String> headers = {
          
          "Content-Type": "application/json"
        };

        response = await dio.delete("$back/$path",
            data: data,
            queryParameters: qsparam,
            options: Options(headers: headers));
      } else {
        Map<String, String> headers = {"Content-Type": "application/json"};
        response = await dio.delete("$back/$path",
            data: data,
            queryParameters: qsparam,
            options: Options(headers: headers));

        if (message && response.statusCode == 200) {
          MakerMessage.error(
              context: Home.homeContext,
              "Deletado",
              Text("Deletado com Sucesso",
                  textAlign: TextAlign.center));
        }
      }
    } on DioException catch (e) {
      if (sync) {
        HttpRequestError(
          
          message: e.response != null ? e.response.toString() : "",
          path: '$back/$path',
          statusCode: e.response!.statusCode ?? 0,
          verbose: "DELETE",
        );
      } else {
        HttpRequestError(
            
            message: e.response!.data["message"],
            path: '/$path',
            statusCode: e.response!.statusCode ?? 0,
            verbose: "DELETE");
      }
    }
    return response.data;
  }

  Future<Map> doPut(
      {required String path,
      Map<String, dynamic>? qsparam,
      bool auth = true,
      required Map<String, dynamic> data,
      bool message = true,
      bool sync = false}) async {
    back = Config.backend;
    late Response response;
    DoPrint.httpRequest(
        "$back:::::\nPUT $path, qsParam:${qsparam.toString()}, auth:$auth");
    try {
      if (auth) {
        Map<String, String> headers = {
          
          "Content-Type": "application/json"
        };

        response = await dio.put("$back/$path",
            data: data,
            queryParameters: qsparam,
            options: Options(headers: headers));
        if (message && response.statusCode == 200 ) {
            MakerMessage.error(
              context: Home.homeContext,
              "Salvo com Sucesso",
              Text("Editado com Sucesso",
                  textAlign: TextAlign.center));
        }
      } else {
        Map<String, String> headers = {"Content-Type": "application/json"};
        response = await dio.put("$back/$path",
            data: data,
            queryParameters: qsparam,
            options: Options(headers: headers));
      }
    } on DioException catch (e) {
      if (sync) {
        HttpRequestError(
          
          message: e.response != null ? e.response.toString() : "",
          path: '$back/$path',
          statusCode: e.response?.statusCode ?? 0,
          verbose: "PUT",
        );
      } else {
        HttpRequestError(
          
          message: e.response != null ? e.response.toString() : "",
          path: '$back/$path',
          statusCode: e.response?.statusCode ?? 0,
          verbose: "PUT",
        );
      }
    }

    return response.data;
  }

  Future<Response> doGetPartial(
      {required String path,
      Map<String, dynamic>? qsparam,
      bool auth = true}) async {
    back = Config.backend;

    late Response response;

    try {
      Map<String, String> headers = {
        
        "Content-Type": "application/json"
      };

      response = await dio.get("$back/$path",
          queryParameters: qsparam, options: Options(headers: headers));
    } on DioException catch (e) {
      HttpRequestError(
          
          message: e.response?.data["message"] ?? "",
          path: '${Config.backend}/$path',
          statusCode: e.response?.statusCode ?? 0,
          verbose: "GET");

      return response;
    }

    return response;
  }
}
