import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

import '../conf.dart';

class InstallPage extends StatefulWidget {
  final bool fixMode;

  InstallPage({Key key, this.fixMode = false}) : super(key: key);

  @override
  _InstallPageState createState() => _InstallPageState();
}

class _InstallPageState extends State<InstallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context, showBackButton: true),
      backgroundColor: getPageBackground(context),
      body: PageView(
        children: [
          _AppInfoPage(
              NetworkImagesIndex.gappFramework,
              "Google Play Framework",
              [],
              S.of(context).c_tip_framework_install),
          _AppInfoPage(NetworkImagesIndex.gappService, "Google Play Service",
              [], S.of(context).c_tip_framework_install),
          _AppInfoPage(NetworkImagesIndex.gappStore, "Google Play Store", [],
              S.of(context).c_tip_store_install),
        ],
      ),
    );
  }
}

class _AppInfoPage extends StatefulWidget {
  final String iconURL;
  final String appName;
  final List<ApkData> apkData;
  final String tipText;

  _AppInfoPage(this.iconURL, this.appName, this.apkData, this.tipText);

  @override
  __AppInfoPageState createState() => __AppInfoPageState();
}

class __AppInfoPageState extends State<_AppInfoPage> {
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
            child: DropdownButton(
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.headline6.color),
              value: "111",
              items: [
                DropdownMenuItem(
                  value: "111",
                  child: Text(
                    "3213231313133",
                  ),
                ),
                DropdownMenuItem(
                  value: "222",
                  child: Text(
                    "2323232323233",
                  ),
                )
              ],
              onChanged: (value) {},
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0.3,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "TIP",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0.3,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(widget.tipText),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
