import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:path_provider/path_provider.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import '../conf.dart';

typedef PageGo = void Function(int);

class InstallMode {
  static const int defaultMode = 0;
  static const int unInstallMode = -1;
  static const int reinstallMode = 1;
}

class InstallPage extends StatefulWidget {
  final int installMode;

  InstallPage({Key key, this.installMode = 0}) : super(key: key);

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
        physics:
            widget.installMode != 0 ? null : NeverScrollableScrollPhysics(),
        children: [
          _AppInfoPage(
            NetworkImagesIndex.gappFramework,
            "Google Play Framework",
            "com.google.android.gsf",
            AppConf.gappsIndex.framework,
            S.of(context).c_tip_framework_install,
            AppConf.networkGappsInfo.framework,
            pageGo: goPage,
            installMode: widget.installMode,
          ),
          _AppInfoPage(
            NetworkImagesIndex.gappService,
            "Google Play Service",
            "com.google.android.gms",
            AppConf.gappsIndex.services,
            S.of(context).c_tip_framework_install,
            AppConf.networkGappsInfo.service,
            pageGo: goPage,
            installMode: widget.installMode,
          ),
          _AppInfoPage(
            NetworkImagesIndex.gappStore,
            "Google Play Store",
            "com.android.vending",
            AppConf.gappsIndex.store,
            S.of(context).c_tip_store_install,
            AppConf.networkGappsInfo.store,
            pageGo: goPage,
            installMode: widget.installMode,
          ),
          InstalledPage(widget.installMode == InstallMode.unInstallMode),
        ],
      ),
    );
  }

  void goPage(int i) {
    controller.animateToPage(controller.page.toInt() + i,
        duration: Duration(milliseconds: 500), curve: Curves.easeOutQuint);
  }
}

class InstalledPage extends StatelessWidget {
  final bool uninstallMode;

  InstalledPage(this.uninstallMode);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).title_all_done,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              uninstallMode
                  ? SizedBox()
                  : Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(S.of(context).c_tip_installed),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _AppInfoPage extends StatefulWidget {
  final String iconURL;
  final String appName;
  final String packageName;
  final Map<int, ApkData> apkData;
  final String tipText;
  final int networkGappsVersion;
  final PageGo pageGo;
  final int installMode;

  _AppInfoPage(this.iconURL, this.appName, this.packageName, this.apkData,
      this.tipText, this.networkGappsVersion,
      {this.pageGo, this.installMode}) {
    assert(pageGo != null);
    assert(installMode != null);
  }
  @override
  __AppInfoPageState createState() => __AppInfoPageState();
}

class __AppInfoPageState extends State<_AppInfoPage>
    with WidgetsBindingObserver {
  int value;

  AppInfo packageInfo;

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

    if (widget.installMode != InstallMode.unInstallMode) {
      value = widget.networkGappsVersion;
    } else {
      value = -2;
    }
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
    try {
      packageInfo = await InstalledApps.getAppInfo(widget.packageName);
      setState(() {});
    } catch (_) {
      packageInfo = null;
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
              content: Text("网络错误，请检查您的网络环境：${err.toString()}"),
              actions: [
                TextButton(
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
    if (packageInfo != null && packageInfo.versionCode > value) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).title_downgrade_install),
              content: Text(S.of(context).c_downgrade_install),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      AppInstaller.unInstallApp(widget.packageName);
                    },
                    child: Text(S.of(context).title_uninstall)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      AppInstaller.installApk(filePath);
                    },
                    child: Text(S.of(context).title_enforce_continue)),
              ],
            );
          });
      return;
    }
    AppInstaller.installApk(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),

            /// App Icon
            Center(
              child: SizedBox(
                height: 128,
                width: 128,
                child: CachedNetworkImage(imageUrl: widget.iconURL),
              ),
            ),

            /// App Name
            Center(
              child: Text(
                widget.appName,
                style: TextStyle(fontSize: 22),
              ),
            ),

            SizedBox(
              height: 5,
            ),

            /// Version Menu
            Center(
              child: Builder(builder: (context) {
                List<DropdownMenuItem> list = [];

                if (widget.installMode != InstallMode.unInstallMode) {
                  widget.apkData.forEach((key, value) {
                    list.add(DropdownMenuItem(
                      value: key,
                      child: ListTile(
                        title: Text(value.versionCode.toString(),
                            textAlign: TextAlign.center),
                        subtitle: Text(value.versionName,
                            textAlign: TextAlign.center),
                      ),
                    ));
                  });
                } else {
                  list.add(DropdownMenuItem(
                    value: -2,
                    child: SizedBox(
                      child: Text(S.of(context).title_uninstall,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                      width: MediaQuery.of(context).size.width,
                    ),
                  ));
                }

                list.add(DropdownMenuItem(
                  value: -1,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(S.of(context).title_skip,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                  ),
                ));

                return DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.headline6.color),
                    value: value,
                    items: list,
                    onChanged: (value) async {
                      if (isDownloading) {
                        return;
                      }
                      updatePackageInfo();
                      setState(() {
                        this.value = value;
                      });
                    },
                  ),
                );
              }),
            ),
            SizedBox(
              height: 30,
            ),

            /// Note Text
            Builder(
              builder: (BuildContext context) {
                if (value == -1 ||
                    value == -2 ||
                    widget.apkData[value].note == null) {
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

            /// Tip Text
            widget.installMode == InstallMode.unInstallMode
                ? SizedBox()
                : Center(
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
              height: 5,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: widget.packageName != "com.google.android.gms" ||
                      widget.installMode == InstallMode.unInstallMode
                  ? null
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(S
                                          .of(context)
                                          .title_installation_failed),
                                      content: Text(
                                          S.of(context).c_installation_failed),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                value = -1;
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("ok"))
                                      ],
                                    );
                                  });
                            },
                            child:
                                Text(S.of(context).title_installation_failed),
                          ),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),

      ///  Bottom Menu
      bottomNavigationBar: BottomAppBar(
        child: ButtonBar(
          mainAxisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: null,
              mini: true,
              backgroundColor: this.value == widget.networkGappsVersion ||
                      widget.installMode == InstallMode.unInstallMode
                  ? Colors.grey
                  : Colors.blue,
              onPressed: this.value == widget.networkGappsVersion ||
                      widget.installMode == InstallMode.unInstallMode
                  ? null
                  : () {
                      setState(() {
                        this.value = widget.networkGappsVersion;
                      });
                    },
              child: Icon(Icons.restore),
              tooltip: S.of(context).title_use_default,
            ),

            /// Supper Button
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
                                valueColor: AlwaysStoppedAnimation(Colors.blue),
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
                                    color: downloadProgress < 0.4
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }

                  /// Uninstall
                  if (value == -2) {
                    return Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (packageInfo == null) {
                              widget.pageGo(1);
                              return;
                            }
                            bool isSystemApp = await InstalledApps.isSystemApp(
                                widget.packageName);
                            if (!isSystemApp) {
                              AppInstaller.unInstallApp(widget.packageName)
                                  .then((value) {
                                setState(() {});
                              });
                              return;
                            }

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(S.of(context).title_error),
                                    content: Text(S
                                        .of(context)
                                        .c_framework_is_system_app),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            AppInstaller.unInstallApp(
                                                    widget.packageName)
                                                .then((value) {
                                              setState(() {});
                                            });
                                          },
                                          child: Text(S
                                              .of(context)
                                              .title_enforce_continue)),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              value = -1;
                                            });
                                          },
                                          child: Text("ok")),
                                    ],
                                  );
                                });
                          },
                          child: Text(packageInfo == null
                              ? S.of(context).title_next
                              : S.of(context).title_uninstall)),
                    );
                  }

                  /// go next
                  if (packageInfo == null || value == -1) {
                    return Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: ElevatedButton(
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

                  bool ok = false;
                  if (widget.installMode == InstallMode.defaultMode) {
                    ok = packageInfo.versionCode >=
                        widget.apkData[value].versionCode;
                  } else if (widget.installMode == InstallMode.unInstallMode) {
                    ok = packageInfo.versionCode == null;
                  } else if (widget.installMode == InstallMode.reinstallMode) {
                    ok = packageInfo.versionCode ==
                        widget.apkData[value].versionCode;
                  }

                  /// Download and install
                  return Padding(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: ElevatedButton(
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
              backgroundColor:
                  value == -1 || value == -2 ? Colors.grey : Colors.blue,
              onPressed: value != -1 && value != -2
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
      ),
    );
  }
}
