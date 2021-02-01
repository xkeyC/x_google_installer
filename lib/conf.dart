import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import 'api.dart';

class AppConf {
  static IndexData _indexData;
  static NetworkGappsInfo _networkGappsInfo;
  static AndroidDeviceInfo _androidDeviceInfo;
  static AppInfo _thisAppInfo;

  static IndexData get gappsIndex {
    return _indexData;
  }

  static AndroidDeviceInfo get androidDeviceInfo {
    return _androidDeviceInfo;
  }

  static NetworkGappsInfo get networkGappsInfo {
    return _networkGappsInfo;
  }

  static AppInfo get thisAppInfo {
    return _thisAppInfo;
  }

  static Future<int> initData({bool enforce = false}) async {
    _thisAppInfo = await InstalledApps.getAppInfo("co.clinux.googleinstaller");

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
        DateTime.now().add(Duration(hours: -1)).millisecondsSinceEpoch >
            lastUpdate ||
        enforce) {
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
      } else {
        _networkGappsInfo = NetworkGappsInfo(-1, -1, -1);
      }
      _indexData = IndexData.formJson(indexJsonString);
      return 1;
    } else {
      _indexData = IndexData.formJson(savedIndexData);
      _networkGappsInfo = NetworkGappsInfo.formJson(savedNetworkGappsInfo);
      return 0;
    }
  }

  static void openUrl(String url) {
    FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.light,
        toolbarColor: Colors.white,
        addDefaultShareMenuItem: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
    );
  }
}

class IndexData {
  int appVersion;
  String urlPath;
  Map<int, ApkData> framework;
  Map<int, ApkData> services;
  Map<int, ApkData> store;

  IndexData(
      this.appVersion, this.urlPath, this.framework, this.services, this.store);

  factory IndexData.formJson(String jsonString) {
    Map m = json.decode(jsonString);
    Map f = m["f"];
    Map<int, ApkData> framework = {};
    f.keys.forEach((id) {
      framework.addAll({
        int.parse(id): ApkData.formMapAndIndex(
            int.parse(id), f[id], "com.google.android.gsf")
      });
    });
    Map s = m["s"];
    Map<int, ApkData> services = {};
    s.keys.forEach((id) {
      services.addAll({
        int.parse(id): ApkData.formMapAndIndex(
            int.parse(id), s[id], "com.google.android.gms")
      });
    });
    Map st = m["st"];
    Map<int, ApkData> store = {};
    st.keys.forEach((id) {
      store.addAll({
        int.parse(id): ApkData.formMapAndIndex(
            int.parse(id), st[id], "com.android.vending")
      });
    });
    return IndexData(
        m["app_version"], m["url_path"], framework, services, store);
  }
}

class ApkData {
  int versionCode;
  String versionName;
  String packageName;
  int minApi;
  String url;
  String note;

  ApkData(this.versionCode, this.versionName, this.packageName, this.minApi,
      this.url, this.note);

  factory ApkData.formMapAndIndex(int index, Map m, String packageName) {
    return ApkData(index, m["version_name"], packageName, m["min_api"],
        m["url"], m["note"]);
  }
}

class NetworkImagesIndex {
  static const String gappFramework =
      "https://static.clinux.co/files/google_installer/img/framework.png";
  static const String gappService =
      "https://static.clinux.co/files/google_installer/img/service.png";
  static const String gappStore =
      "https://static.clinux.co/files/google_installer/img/play.png";
}
