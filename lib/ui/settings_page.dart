import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context,
          showBackButton: true,
          title: Text(
            S.of(context).title_settings,
            style: TextStyle(color: getTextColor(context)),
          )),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(S.of(context).title_remove_download_file),
              subtitle: Text(cacheString),
              onTap: () async {
                final path =
                    (await getExternalStorageDirectory()).path + "/apk";
                Directory directory = Directory(path);
                if (!await directory.exists()) {
                  return;
                }
                await directory.delete(recursive: true);
                _updateCacheString();
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(S.of(context).title_check_update),
              subtitle: Text("coolapk.com"),
              onTap: () {
                FlutterWebBrowser.openWebPage(
                  url: "https://www.coolapk.com/apk/co.clinux.googleinstaller",
                  customTabsOptions: CustomTabsOptions(
                    colorScheme: CustomTabsColorScheme.light,
                    toolbarColor: Colors.white,
                    addDefaultShareMenuItem: true,
                    showTitle: true,
                    urlBarHidingEnabled: true,
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(S.of(context).title_about_us),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
