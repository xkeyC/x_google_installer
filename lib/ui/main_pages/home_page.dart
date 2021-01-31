import 'package:cached_network_image/cached_network_image.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import '../../conf.dart';
import '../install_page.dart';

class GoogleFrameworkStatus {
  AppInfo framework;
  AppInfo service;
  AppInfo store;

  GoogleFrameworkStatus(this.framework, this.service, this.store);

  int getStatusCode() {
    if (framework == null && service == null && store == null) {
      return -1;
    }
    if (framework == null || service == null || store == null) {
      return -2;
    }
    if (AppConf.networkGappsInfo.framework != -1) {
      if (framework.versionCode < AppConf.networkGappsInfo.framework ||
          service.versionCode < AppConf.networkGappsInfo.service ||
          store.versionCode < AppConf.networkGappsInfo.store) {
        return 1;
      }
    }
    return 0;
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  GoogleFrameworkStatus status = GoogleFrameworkStatus(null, null, null);

  /// check GApps Status
  void checkState() async {
    AppInfo framework;
    try {
      framework = await InstalledApps.getAppInfo("com.google.android.gsf");
    } catch (e) {
      print(e);
    }
    AppInfo service;
    try {
      service = await InstalledApps.getAppInfo("com.google.android.gms");
    } catch (e) {
      print(e);
    }
    AppInfo store;
    try {
      store = await InstalledApps.getAppInfo("com.android.vending");
    } catch (e) {
      print(e);
    }
    setState(() {
      status = GoogleFrameworkStatus(framework, service, store);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkState();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) {
      checkState();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getPageBackground(context),
      body: RefreshIndicator(
        onRefresh: () async {
          final code = await AppConf.initData(enforce: true);
          if (code == null) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(S.of(context).title_error),
                    content: Text(S.of(context).c_err_connect_server),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("ok")),
                    ],
                  );
                });
            return;
          }
          checkState();
        },
        child: ListView(
          children: [
            StateBanner(status.getStatusCode()),
            SizedBox(
              height: 4,
            ),
            DeviceInformationBanner(),
            GappsBanner(status),
            SizedBox(
              child: Builder(builder: (BuildContext context) {
                String text;

                switch (status.getStatusCode()) {
                  case -1:
                    text = S.of(context).title_install_google;
                    break;
                  case -2:
                    text = S.of(context).title_fix_google;
                    break;
                  case 0:
                    text = S.of(context).title_open_google;
                    break;
                  case 1:
                    text = S.of(context).title_upgrade_google;
                    break;
                  default:
                    break;
                }
                return Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .2,
                      right: MediaQuery.of(context).size.width * .2),
                  child: ElevatedButton(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (status.getStatusCode() < 0 ||
                          status.getStatusCode() == 1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return InstallPage();
                        }));
                      }
                      if (status.getStatusCode() == 0) {
                        LaunchApp.openApp(
                            androidPackageName: "com.android.vending");
                      }
                    },
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class GappsBanner extends StatefulWidget {
  final GoogleFrameworkStatus status;

  GappsBanner(this.status);

  @override
  _GappsBannerState createState() => _GappsBannerState();
}

class _GappsBannerState extends State<GappsBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 8),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.google,
                        size: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        S.of(context).title_google_apps_status,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    AppInfo info;
                    String iconUrl;
                    String appName;
                    int networkVersionCode;
                    switch (index) {
                      case 0:
                        info = widget.status.framework;
                        iconUrl = NetworkImagesIndex.gappFramework;
                        appName = "Google Play Framework";
                        networkVersionCode = AppConf.networkGappsInfo.framework;
                        break;
                      case 1:
                        info = widget.status.service;
                        iconUrl = NetworkImagesIndex.gappService;
                        appName = "Google Play Services";
                        networkVersionCode = AppConf.networkGappsInfo.service;
                        break;
                      case 2:
                        info = widget.status.store;
                        iconUrl = NetworkImagesIndex.gappStore;
                        appName = "Google Play Store";
                        networkVersionCode = AppConf.networkGappsInfo.store;
                        break;
                      default:
                        info = null;
                    }

                    if (info == null) {
                      return ListTile(
                        title: Text(appName),
                        subtitle: Text(S.of(context).title_not_install),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: CachedNetworkImage(
                            imageUrl: iconUrl,
                          ),
                        ),
                        trailing: FaIcon(
                          FontAwesomeIcons.times,
                          color: Colors.red,
                        ),
                      );
                    }

                    return ListTile(
                      title: Text(info.name),
                      subtitle: Text(networkVersionCode > info.versionCode
                          ? "${info.versionCode} ->>> $networkVersionCode"
                          : "${info.versionName}  (${info.versionCode})"),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CachedNetworkImage(
                          imageUrl: iconUrl,
                        ),
                      ),
                      trailing: networkVersionCode > info.versionCode
                          ? Icon(
                              Icons.fiber_new,
                              color: Colors.red,
                            )
                          : FaIcon(
                              FontAwesomeIcons.check,
                              color: Colors.green,
                            ),
                    );
                  })
            ],
          ),
        ));
  }
}

class DeviceInformationBanner extends StatefulWidget {
  @override
  _DeviceInformationBannerState createState() =>
      _DeviceInformationBannerState();
}

class _DeviceInformationBannerState extends State<DeviceInformationBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10, top: 8, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.code,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      S.of(context).title_deviceInfo,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                makeDeviceInfoRow(
                    context,
                    Icon(
                      Icons.android,
                      size: 32,
                      color: const Color.fromARGB(255, 61, 218, 132),
                    ),
                    "Android${AppConf.androidDeviceInfo.version.release}",
                    "Sdk${AppConf.androidDeviceInfo.version.sdkInt}"),
                makeDeviceInfoRow(
                  context,
                  Icon(
                    Icons.developer_board,
                    size: 32,
                    color: Colors.black,
                  ),
                  S.of(context).title_architecture,
                  "${AppConf.androidDeviceInfo.supportedAbis[0]}",
                ),
                makeDeviceInfoRow(
                    context,
                    Icon(
                      Icons.phone_android,
                      size: 32,
                      color: Colors.black,
                    ),
                    "${AppConf.androidDeviceInfo.manufacturer}",
                    "${AppConf.androidDeviceInfo.model}")
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

Widget makeDeviceInfoRow(
    BuildContext context, Widget icon, String title, String subtitle,
    {double subtitleSize = 13}) {
  return Padding(
    padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:CrossAxisAlignment.center,
      children: [
        icon,
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 100,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: subtitleSize,
                color: Colors.black.withAlpha(120),
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    ),
  );
}

class StateBanner extends StatefulWidget {
  /// ok:0 nothing:-1 incomplete:-2
  final int status;

  StateBanner(this.status);

  @override
  _StateBannerState createState() => _StateBannerState();
}

class _StateBannerState extends State<StateBanner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: getBannerColorWithStatus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: getBannerIconWithStatus(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                getBannerTextWithStatus(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  String getBannerTextWithStatus() {
    switch (widget.status) {
      case 0:
        return S.of(context).c_framework_ok;
      case -1:
        return S.of(context).c_framework_error;
      case -2:
        return S.of(context).c_framework_warning;
      case 1:
        return S.of(context).c_framework_update;
      default:
        return "?";
    }
  }

  Color getBannerColorWithStatus() {
    switch (widget.status) {
      case 1:
        return Colors.orange;
      case 0:
        return Colors.green;
      case -1:
        return Colors.red;
      case -2:
        return Colors.amberAccent;
      default:
        return Colors.white;
    }
  }

  Widget getBannerIconWithStatus() {
    const size = 48.00;
    const color = Colors.white;
    switch (widget.status) {
      case 1:
        return Icon(
          Icons.new_releases,
          size: size,
          color: color,
        );
      case 0:
        return FaIcon(
          FontAwesomeIcons.check,
          size: size,
          color: color,
        );
      case -1:
        return FaIcon(FontAwesomeIcons.times, size: size, color: color);
      case -2:
        return FaIcon(FontAwesomeIcons.exclamationTriangle,
            size: size, color: color);
      default:
        return Icon(
          Icons.help,
          size: size,
          color: color,
        );
    }
  }
}
