import 'dart:convert';

import 'package:dio/dio.dart';

class Api {
  static Dio _dio;

  static init() {
    if (_dio == null) {
      _dio = Dio()
        ..options.baseUrl = "https://static.clinux.co/files/google_installer/"
        ..options.responseType = ResponseType.plain;
    }
  }

  static Future<String> getIndexData() async {
    return (await _dio.get("index.json")).data;
  }

  static Future<String> getNetworkGappsInfo(int sdkInt) async {
    try {
      return (await _dio.get("conf/$sdkInt.json")).data;
    } catch (e) {
      return null;
    }
  }
}

class NetworkGappsInfo {
  int framework;
  int service;
  int store;

  NetworkGappsInfo(this.framework, this.service, this.store);

  factory NetworkGappsInfo.formJson(String jsonMap) {
    Map m = json.decode(jsonMap);
    return NetworkGappsInfo(
        int.parse(m["f"]), int.parse(m["s"]), int.parse(m["st"]));
  }
}
