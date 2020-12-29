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
}
