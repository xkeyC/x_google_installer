import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import '../conf.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String cacheString = "...";

  @override
  void initState() {
    _updateCacheString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context,
          showBackButton: true,
          title: Text(
            S.of(context).title_settings,
            style: TextStyle(
                color: getTextColor(context), fontWeight: FontWeight.bold),
          )),
      body: ListView(
        children: [
          makeItemCard(
              Text(S.of(context).title_remove_download_file), Text(cacheString),
              () async {
            final path = (await getExternalStorageDirectory()).path + "/apk";
            Directory directory = Directory(path);
            if (!await directory.exists()) {
              return;
            }
            await directory.delete(recursive: true);
            _updateCacheString();
          }),
          makeItemCard(
              Text(S.of(context).title_check_update), Text("coolapk.com"), () {
            AppConf.openUrl(
                "https://www.coolapk.com/apk/co.clinux.googleinstaller");
          }),
          makeItemCard(Text(S.of(context).title_about), null, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AboutPage();
            }));
          })
        ],
      ),
    );
  }

  Widget makeItemCard(Widget title, Widget subTitle, GestureTapCallback onTap) {
    return ListTile(
      title: title,
      subtitle: subTitle,
      onTap: onTap,
    );
  }

  void _updateCacheString() async {
    setState(() {
      cacheString = "...";
    });
    final path = (await getExternalStorageDirectory()).path + "/apk";
    Directory directory = Directory(path);
    int size = 0;
    if (await directory.exists()) {
      await directory.list().forEach((element) async {
        File file = File(element.path);
        size += await file.length();
      });
    }
    setState(() {
      cacheString = "${(size.toDouble() / 1024 / 1024).toStringAsFixed(2)} MB";
    });
  }
}
