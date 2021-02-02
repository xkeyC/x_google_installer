import 'package:flutter/services.dart';

class AppChannel {
  static final _channel = const MethodChannel("x_google_install");
  static Future<bool> checkRoot() async {
    return await _channel.invokeMethod<bool>("checkRoot");
  }
}
