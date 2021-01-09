import 'package:flutter/material.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/main_pages/home_page.dart';
import 'package:x_google_installer/ui/widgets.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context,
          title: Text(
            "X Google Installer",
            style: TextStyle(color: getTextColor(context)),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: S.of(context).title_uninstall,
              onPressed: () {},
              color: getTextColor(context),
            ),
            IconButton(
              tooltip: S.of(context).title_about_us,
              icon: Icon(Icons.settings),
              onPressed: () {},
              color: getTextColor(context),
            )
          ]),
      body: IndexedStack(
        index: 0,
        children: [HomePage()],
      ),
    );
  }
}
