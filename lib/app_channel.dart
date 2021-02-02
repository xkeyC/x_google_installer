import 'package:flutter/services.dart';

class AppChannel {
  static final _channel = const MethodChannel("x_google_install");
  static Future<bool> checkRoot() async {
    return await _channel.invokeMethod<bool>("checkRoot");
  }

  static Future<bool> startWifiAdb() async {
    return await _channel.invokeMethod<bool>("startWifiAdb");
  }

  static Future<bool> connectToWifiAdb() async {
    return await _channel.invokeMethod<bool>("connectToWifiAdb");
  }

  static Future<int> checkSyslock() async {
    return await _channel.invokeMethod<int>("checkSyslock");
  }
}
