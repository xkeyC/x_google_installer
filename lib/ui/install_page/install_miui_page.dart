import 'package:flutter/material.dart';
import 'package:x_google_installer/app_channel.dart';

class InstallMiuiPage extends StatefulWidget {
  @override
  _InstallMiuiPageState createState() => _InstallMiuiPageState();
}

class _InstallMiuiPageState extends State<InstallMiuiPage> {
  @override
  void initState() {
    AppChannel.checkRoot().then((value) {
      print(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
