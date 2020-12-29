import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x_google_installer/generated/l10n.dart';
import 'package:x_google_installer/ui/widgets.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

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
              icon: Icon(Icons.help),
              onPressed: () {},
              color: getTextColor(context),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StateBanner(0),
          ],
        ),
      ),
    );
  }
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
      height: 130,
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
            child: Text(
              getBannerTextWithStatus(),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
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
      default:
        return "?";
    }
  }

  Color getBannerColorWithStatus() {
    switch (widget.status) {
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
