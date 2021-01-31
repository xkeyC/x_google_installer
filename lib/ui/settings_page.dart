import 'package:flutter/material.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: makeAppBar(context,
          showBackButton: true,
          title: Text(
            S.of(context).title_settings,
            style: TextStyle(color: getTextColor(context)),
          )),
    );
  }
}
