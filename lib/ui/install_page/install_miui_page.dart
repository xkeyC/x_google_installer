import 'package:flutter/material.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import '../../app_channel.dart';

typedef PageGo = void Function(int);

class InstallMiuiPage extends StatefulWidget {
  @override
  _InstallMiuiPageState createState() => _InstallMiuiPageState();
}

class _InstallMiuiPageState extends State<InstallMiuiPage> {
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context, showBackButton: true),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [_CheckRootPage(goPage), _CheckSyslock(goPage)],
      ),
    );
  }

  void goPage(int i) {
    controller.animateToPage(controller.page.toInt() + i,
        duration: Duration(milliseconds: 500), curve: Curves.easeOutQuint);
  }
}

class _CheckSyslock extends StatefulWidget {
  final PageGo pageGo;

  _CheckSyslock(this.pageGo);

  @override
  _CheckSyslockState createState() => _CheckSyslockState(pageGo);
}

class _CheckSyslockState extends State<_CheckSyslock> {
  final PageGo pageGo;

  int status = 0;

  _CheckSyslockState(this.pageGo);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).title_check_syslock,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(getText()),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      onTap: status == 0 || status == -1
          ? () async {
              setState(() {
                status = 1;
              });
              bool adb = await AppChannel.startWifiAdb();
              if (!checkBool(adb)) {
                return;
              }
              setState(() {
                status = 2;
              });
              bool adbc = await AppChannel.connectToWifiAdb();
              if (!checkBool(adbc)) {
                return;
              }
              setState(() {
                status = 3;
              });
              int sysLock = await AppChannel.checkSyslock();
              if (sysLock == -1) {
                setState(() {
                  status = -1;
                });
              } else if (sysLock == 1) {
                /// need reboot
              } else if (sysLock == 1) {
                /// next

              }
            }
          : null,
    );
  }

  bool checkBool(bool b) {
    if (!b) {
      setState(() {
        status = -1;
      });
      return false;
    }
    return true;
  }

  String getText() {
    switch (status) {
      case -1:
        return "failed";
      case 0:
        return S.of(context).title_click_to_start;
      case 1:
        return S.of(context).title_start_wifi_adb;
      case 2:
        return S.of(context).title_connect_to_adb;
      case 3:
        return S.of(context).title_check_syslock_status;
      default:
        return "";
    }
  }
}

class _CheckRootPage extends StatefulWidget {
  final PageGo pageGo;

  const _CheckRootPage(this.pageGo, {Key key}) : super(key: key);

  @override
  __CheckRootPageState createState() => __CheckRootPageState(pageGo);
}

class __CheckRootPageState extends State<_CheckRootPage> {
  final PageGo pageGo;
  int rootStatus = -2;

  __CheckRootPageState(this.pageGo);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Center(
        child: Text(getTextWithStatus()),
      ),
      onTap: rootStatus == 0
          ? null
          : () async {
              setState(() {
                rootStatus = 0;
              });
              var ok = await AppChannel.checkRoot();
              if (!ok) {
                setState(() {
                  rootStatus = -1;
                });
                return;
              }
              pageGo(1);
            },
    );
  }

  String getTextWithStatus() {
    switch (rootStatus) {
      case -2:
        return S.of(context).title_click_to_start;
      case -1:
        return S.of(context).title_no_root;
      case 0:
        return S.of(context).title_checking_root;
      default:
        return "";
    }
  }
}
