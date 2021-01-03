import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import '../conf.dart';

typedef PageGo = void Function(int);

class InstallPage extends StatefulWidget {
  final bool fixMode;

  InstallPage({Key key, this.fixMode = false}) : super(key: key);

  @override
  _InstallPageState createState() => _InstallPageState();
}

class _InstallPageState extends State<InstallPage> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context, showBackButton: true),
      backgroundColor: getPageBackground(context),
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _AppInfoPage(
              NetworkImagesIndex.gappFramework,
              "Google Play Framework",
              AppConf.gappsIndex.framework,
              S.of(context).c_tip_framework_install,
              AppConf.networkGappsInfo.framework,
              pageGo: goPage),
          _AppInfoPage(
              NetworkImagesIndex.gappService,
              "Google Play Service",
              AppConf.gappsIndex.services,
              S.of(context).c_tip_framework_install,
              AppConf.networkGappsInfo.service,
              pageGo: goPage),
          _AppInfoPage(
              NetworkImagesIndex.gappStore,
              "Google Play Store",
              AppConf.gappsIndex.store,
              S.of(context).c_tip_store_install,
              AppConf.networkGappsInfo.store,
              pageGo: goPage),
        ],
      ),
    );
  }

  void goPage(int i) {
    controller.animateToPage(controller.page.toInt() + i,
        duration: Duration(seconds: 1), curve: Curves.easeOutQuint);
  }
}

class _AppInfoPage extends StatefulWidget {
  final String iconURL;
  final String appName;
  final Map<int, ApkData> apkData;
  final String tipText;
  final int networkGappsVersion;
  final PageGo pageGo;

  _AppInfoPage(this.iconURL, this.appName, this.apkData, this.tipText,
      this.networkGappsVersion,
      {this.pageGo}) {
    assert(pageGo != null);
  }
  @override
  __AppInfoPageState createState() => __AppInfoPageState();
}

class __AppInfoPageState extends State<_AppInfoPage>
    with WidgetsBindingObserver {
  int value;

  PackageInfo packageInfo;

  bool isDownloading = false;
  double downloadProgress = 0.0;

  Dio _dio = Dio();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    widget.apkData.forEach((id, apk) {
      if (AppConf.androidDeviceInfo.version.sdkInt < apk.minApi) {
        widget.apkData.remove(id);
      }
    });

    value = widget.networkGappsVersion;
    updatePackageInfo();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) {
      updatePackageInfo();
    }
    super.didChangeAppLifecycleState(state);
  }

  void updatePackageInfo() async {
    if (value != -1 && widget.apkData.length != 0) {
      try {
        packageInfo = await PackageInfo.fromPlatformByPackageName(
            widget.apkData[value].packageName);
        setState(() {});
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void downloadFile() async {
    final apkData = widget.apkData[value];
    final path = (await getExternalStorageDirectory()).path +
        "/apk/${apkData.packageName}_${apkData.versionName}.apk";
    if (await File(path).exists()) {
      installApk(path);
      return;
    }
    setState(() {
      isDownloading = true;
    });
    final dPath = path + ".download";
    _dio.download(apkData.url, dPath,
        onReceiveProgress: (int count, int total) {
      setState(() {
        downloadProgress = (count.toDouble() / total);
      });
    }).then((r) async {
      print(r);
      final downloadedFile = File(dPath);
      if (!await downloadedFile.exists()) {
        print("file not found");
        return;
      }
      await downloadedFile.rename(path);
      setState(() {
        isDownloading = false;
      });
      installApk(path);
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("ERROR"),
              content: Text(err.toString()),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("ok"),
                )
              ],
            );
          });
      setState(() {
        isDownloading = false;
      });
    });
  }

  void installApk(String filePath) {
    AppInstaller.installApk(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Center(
            child: SizedBox(
              height: 128,
              width: 128,
              child: CachedNetworkImage(imageUrl: widget.iconURL),
            ),
          ),
          Center(
            child: Text(
              widget.appName,
              style: TextStyle(fontSize: 22),
            ),
          ),
          Center(
            child: Builder(builder: (context) {
              List<DropdownMenuItem> list = [];

              widget.apkData.forEach((key, value) {
                list.add(DropdownMenuItem(
                  value: key,
                  child: Text(
                    "<${value.versionCode}>  ${value.versionName}",
                  ),
                ));
              });

              list.add(DropdownMenuItem(
                value: -1,
                child: Text(
                  S.of(context).title_skip,
                ),
              ));

              return DropdownButton(
                isExpanded: true,
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.headline6.color),
                value: value,
                items: list,
                onChanged: (value) async {
                  updatePackageInfo();
                  setState(() {
                    this.value = value;
                  });
                },
              );
            }),
          ),
          SizedBox(
            height: 10,
          ),
          Builder(
            builder: (BuildContext context) {
              if (value == -1 || widget.apkData[value].note == null) {
                return SizedBox();
              }
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 0.3,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.apkData[value].note,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0.1,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    widget.tipText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: null,
                mini: true,
                backgroundColor: this.value == widget.networkGappsVersion
                    ? Colors.grey
                    : Colors.blue,
                onPressed: this.value == widget.networkGappsVersion
                    ? null
                    : () {
                        setState(() {
                          this.value = widget.networkGappsVersion;
                        });
                      },
                child: Icon(Icons.restore),
                tooltip: S.of(context).title_use_default,
              ),
              SizedBox(
                width: isDownloading ? 120 : 120,
                child: Builder(
                  builder: (BuildContext context) {
                    if (isDownloading) {
                      return Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0),
                            child: Card(
                              elevation: 3,
                              child: SizedBox(
                                height: 36,
                                width: 140,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                  value: downloadProgress,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: SizedBox(
                                width: 120,
                                child: Text(
                                  "${(downloadProgress * 100).toStringAsFixed(2)}%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: downloadProgress < 0.5
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }

                    if (packageInfo == null || value == -1) {
                      return Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (value == -1) {
                              widget.pageGo(1);
                              return;
                            }
                            downloadFile();
                          },
                          child: Text(value == -1
                              ? S.of(context).title_skip
                              : S.of(context).title_start_install),
                        ),
                      );
                    }

                    bool ok = int.parse(packageInfo.buildNumber) >=
                        widget.apkData[value].versionCode;

                    return Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          if (ok) {
                            widget.pageGo(1);
                            return;
                          }
                          downloadFile();
                        },
                        child: Text(ok
                            ? S.of(context).title_next
                            : S.of(context).title_start_install),
                      ),
                    );
                  },
                ),
              ),
              FloatingActionButton(
                heroTag: null,
                mini: true,
                backgroundColor: value == -1 ? Colors.grey : Colors.blue,
                onPressed: value != -1
                    ? () {
                        FlutterWebBrowser.openWebPage(
                          url: widget.apkData[value].url,
                          customTabsOptions: CustomTabsOptions(
                            colorScheme: CustomTabsColorScheme.light,
                            toolbarColor: Colors.white,
                            addDefaultShareMenuItem: true,
                            showTitle: true,
                            urlBarHidingEnabled: true,
                          ),
                        );
                      }
                    : null,
                child: FaIcon(FontAwesomeIcons.chrome),
                tooltip: S.of(context).title_install_with_browser,
              )
            ],
          ),
        ],
      ),
    );
  }
}
