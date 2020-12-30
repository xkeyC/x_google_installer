import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api.dart';

class AppConf {
  static IndexData _indexData;
  static NetworkGappsInfo _networkGappsInfo;
  static AndroidDeviceInfo _androidDeviceInfo;

  static AndroidDeviceInfo get androidDeviceInfo {
    return _androidDeviceInfo;
  }

  static NetworkGappsInfo get networkGappsInfo {
    return _networkGappsInfo;
  }


  static Future<int> initData() async {
    if (Platform.isAndroid) {
      _androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }

    await Hive.initFlutter();
    var box = await Hive.openBox('appConfig');
    final lastUpdate = box.get("lastUpdate");
    final savedIndexData = box.get("index.json");
    final savedNetworkGappsInfo =
        box.get("conf_${_androidDeviceInfo.version.sdkInt}.json");
    if (lastUpdate == null ||
        savedIndexData == null ||
        savedNetworkGappsInfo == null ||
        DateTime.now().add(Duration(days: -1)).millisecondsSinceEpoch >
            lastUpdate) {
      print("getting...");
      String indexJsonString;
      try {
        indexJsonString = await Api.getIndexData();
      } catch (_) {
        return null;
      }
      String netJsonString =
          await Api.getNetworkGappsInfo(_androidDeviceInfo.version.sdkInt);
      box.put("index.json", indexJsonString);
      box.put("lastUpdate", DateTime.now().millisecondsSinceEpoch);
      if (netJsonString != null) {
        box.put(
            "conf_${_androidDeviceInfo.version.sdkInt}.json", netJsonString);
        _networkGappsInfo = NetworkGappsInfo.formJson(netJsonString);
      }
      _indexData = IndexData.formJson(indexJsonString);
      return 1;
    } else {
      _indexData = IndexData.formJson(savedIndexData);
      _networkGappsInfo = NetworkGappsInfo.formJson(savedNetworkGappsInfo);
      return 0;
    }
  }
}

class IndexData {
  int appVersion;
  String urlPath;
  Map framework;
  Map services;
  Map store;

  IndexData(
      this.appVersion, this.urlPath, this.framework, this.services, this.store);

  factory IndexData.formJson(String jsonString) {
    Map m = json.decode(jsonString);
    return IndexData(m["app_version"], m["url_path"], m["f"], m["s"], m["st"]);
  }
}

class ApkData {
  int versionCode;
  String versionName;
  int minApi;
  String url;
  String note;

  ApkData(this.versionCode, this.versionName, this.minApi, this.url, this.note);

  factory ApkData.formMapAndIndex(int index, Map m) {
    return ApkData(index, m["version_name"], m["min_api"], m["url"], m["note"]);
  }
}
