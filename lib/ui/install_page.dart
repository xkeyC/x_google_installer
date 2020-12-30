import 'package:flutter/material.dart';
import 'package:x_google_installer/ui/widgets.dart';

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
      body: PageView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Text(index.toString());
          }),
    );
  }
}
