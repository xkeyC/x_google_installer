import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:x_google_installer/conf.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import 'donor_list.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context,
          showBackButton: true,
          title: Text(
            S.of(context).title_about,
            style: TextStyle(
                color: getTextColor(context), fontWeight: FontWeight.bold),
          )),
      backgroundColor: getPageBackground(context),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),

          /// App Icon
          Center(
            child: SizedBox(
              height: 100,
              child: Image.asset("assets/appLogo.png"),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          /// App Name
          Center(
            child: Text(
              "X Google Install",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              "${AppConf.thisAppInfo.versionName} <${AppConf.thisAppInfo.versionCode}>",
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          makeItemCard(Text(S.of(context).title_opens_source_license), null,
              () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => LicensePage(
                    applicationName: "XGI",
                    applicationVersion: AppConf.thisAppInfo.versionName,
                    applicationIcon: Padding(
                      padding: EdgeInsets.all(20),
                      child: SizedBox(
                        height: 65,
                        width: 65,
                        child: Image.memory(AppConf.thisAppInfo.icon),
                      ),
                    ),
                    applicationLegalese:
                        AppConf.thisAppInfo.versionCode.toString(),
                  ),
                ));
          }),
          makeItemCard(Text(S.of(context).title_project_home_site),
              Text("https://github.com/clinux-co/x_google_installer"), () {
            AppConf.openUrl("https://github.com/clinux-co/x_google_installer");
          }),
          makeItemCard(
              Text(S.of(context).title_project_main_developer), Text("xkeyC"),
              () {
            AppConf.openUrl("https://github.com/xkeyC");
          }),
          makeItemCard(
              Text(S.of(context).title_donate), Text(S.of(context).c_donate),
              () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return DonatePage();
                });
          }),
          makeItemCard(
              Text(S.of(context).title_join_qq_group), Text("204719969"), () {
            AppConf.openUrl("https://jq.qq.com/?_wv=1027&k=HCNvu5uR");
          })
        ],
      ),
    );
  }

  Widget makeItemCard(Widget title, Widget subTitle, GestureTapCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(1),
      ),
      elevation: 0.1,
      child: ListTile(
        title: title,
        subtitle: subTitle,
        onTap: onTap,
      ),
    );
  }
}

class DonatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        makeAppBar(context, showBackButton: true),
        SizedBox(
          height: 5,
        ),
        Text(
          S.of(context).c_donate_tip,
          style: TextStyle(color: Colors.black45, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Scrollbar(
            child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                tooltip: "Alipay",
                icon: FaIcon(
                  FontAwesomeIcons.alipay,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.pop(context);

                  /// Alipay Url
                  AppConf.openUrl(
                      "https://qr.alipay.com/fkx109967giebsup1xorm20?t=1612179151276");
                },
                iconSize: 58,
              ),
              IconButton(
                tooltip: "WeCaht Pay",
                icon: FaIcon(
                  FontAwesomeIcons.weixin,
                  color: Colors.green,
                ),
                onPressed: () {
                  _showQRCode(context, "WeChat Pay",
                      "wxp://f2f0FgCoP4eGiog4m80eR0dY8llbm9kcD9R-");
                },
                iconSize: 58,
              ),
              IconButton(
                tooltip: "QQ Pay",
                icon: FaIcon(
                  FontAwesomeIcons.qq,
                  color: Colors.black,
                ),
                onPressed: () {
                  _showQRCode(context, "QQ Pay",
                      "https://i.qianbao.qq.com/wallet/sqrcode.htm?m=tenpay&f=wallet&a=1&ac=CAEQiK6etgwY9NLfgAY%3D_xxx_sign&u=3334969096&n=xkeyC");
                },
                iconSize: 58,
              ),
              IconButton(
                tooltip: "PayPal",
                icon: FaIcon(
                  FontAwesomeIcons.paypal,
                  color: Color.fromARGB(255, 37, 59, 128),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  AppConf.openUrl("https://www.paypal.me/xkeyC");
                },
                iconSize: 64,
              ),
            ],
          ),
        )),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DonorListPage();
              }));
            },
            child: Text(S.of(context).title_view_donor_list),
          ),
        )
      ],
    );
  }

  _showQRCode(BuildContext context, String title, String data) async {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return QRCodePage(title, data);
        });
  }
}

class QRCodePage extends StatelessWidget {
  final String title;
  final String data;

  QRCodePage(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        makeAppBar(context,
            title: Text(
              title,
              style: TextStyle(
                  color: getTextColor(context), fontWeight: FontWeight.bold),
            ),
            showBackButton: true),
        QrImage(
          data: data,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ],
    );
  }
}
